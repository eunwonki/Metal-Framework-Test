//
//  MV+Metal.swift
//  MetalRenderer
//
//  Created by skia on 2022/01/06.
//

import MetalKit
import ModelIO
import SwiftUI
import SceneKit
import SceneKit.ModelIO

private let RADIUS = Float(0.7)
private var DELTA = Float(0.0000)
private let SOFTENING = Float(0.4)

var kVelocityScale: CGFloat = 0.005
var kRotationDamping: CGFloat = 0.98
var angularVelocity: CGPoint = .zero
var angle: CGPoint = .zero

extension MetalView {
    class Coordinator: NSObject, MTKViewDelegate {
        struct MTKMeshObj {
            var vertexCount: Int?
            var vertexBuffer: MTLBuffer?
            var normalBuffer: MTLBuffer?
            var triangleBuffer: MTLBuffer?
            var centerPos: SCNVector3?
        }
        
        var parent: MetalView
        var ciContext: CIContext!
        var metalDevice: MTLDevice!
        var metalCommandQueue: MTLCommandQueue!
        var mesh: MTKMesh?
        var vertexBuffer: MTLBuffer!
        var pipelineState: MTLRenderPipelineState!
        
        var obj: MTKMeshObj!
        fileprivate var renderParams: MTLBuffer!
        
        init(_ parent: MetalView, mtkView: MTKView) {
            self.parent = parent
            
            mtkView.device = MTLCreateSystemDefaultDevice()
            self.metalDevice = mtkView.device!
            
            self.ciContext = CIContext(mtlDevice: metalDevice!)
            self.metalCommandQueue = metalDevice!.makeCommandQueue()
            
            super.init()
            mtkView.framebufferOnly = false
            mtkView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
            mtkView.drawableSize = mtkView.frame.size
            mtkView.enableSetNeedsDisplay = true
            
            self.obj = read()
            parent.setupCamera(lookAt: obj.centerPos!)
            
            let defaultLibrary = metalDevice!.makeDefaultLibrary()!
            let fragmentProgram = defaultLibrary.makeFunction(name: "frag")
            let vertexProgram = defaultLibrary.makeFunction(name: "vert")
                
            let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
            pipelineStateDescriptor.vertexFunction = vertexProgram
            pipelineStateDescriptor.fragmentFunction = fragmentProgram
            pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm

            self.pipelineState = try! metalDevice!.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        }
        
        func updateCamera() {
            guard let device = metalDevice else { return }
            
            let modelMatrix = SCNMatrix4Identity
            let viewMatrix = SCNMatrix4Invert(parent.camNode.transform)
            let projectionMatrix = parent.camNode.camera!.projectionTransform
            
            let mvp = modelMatrix * viewMatrix * projectionMatrix
//            NSLog("\(viewMatrix)")
                
            let renderParamsSize = MemoryLayout<matrix_float4x4>.size
            renderParams = device.makeBuffer(length: renderParamsSize, options: .cpuCacheModeWriteCombined)
            memcpy(renderParams.contents(), mvp.matrix, MemoryLayout<matrix_float4x4>.size)
        }
        
        func read() -> MTKMeshObj {
            var obj = MTKMeshObj()
            
            let url = Bundle.main.url(forResource: "scene", withExtension: "obj")!
            let mesh = MDLAsset(url: url).object(at: 0) as! MDLMesh
            
            let geometry = SCNGeometry(mdlMesh: mesh)
            let centerPos = geometry.boundingSphere.center
            obj.centerPos = centerPos
            
            let position
                = mesh.vertexAttributeData(forAttributeNamed: MDLVertexAttributePosition, as: .float3)?
                .dataStart.bindMemory(to: SIMD3<Float>.self, capacity: mesh.vertexCount)
            let normal
                = mesh.vertexAttributeData(forAttributeNamed: MDLVertexAttributeNormal, as: .float3)?
                .dataStart.bindMemory(to: SIMD3<Float>.self, capacity: mesh.vertexCount)
            
            let length = MemoryLayout<SIMD3<Float>>.size * mesh.vertexCount
            obj.vertexCount = mesh.vertexCount
            obj.vertexBuffer = metalDevice.makeBuffer(bytes: position!,
                                                         length: length,
                                                         options: [])
            obj.normalBuffer = metalDevice.makeBuffer(bytes: normal!,
                                                         length: length,
                                                         options: [])
            
            return obj
        }
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
        
        func draw(in view: MTKView) {
            guard let drawable = view.currentDrawable else {
                return
            }
            
            updateCamera()
            
            let commandBuffer = metalCommandQueue.makeCommandBuffer()
            let rpd = view.currentRenderPassDescriptor
            rpd?.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 0)
            rpd?.colorAttachments[0].loadAction = .clear
            rpd?.colorAttachments[0].storeAction = .store
            
            if let commandBuffer = commandBuffer,
               let renderEncoder = commandBuffer
               .makeRenderCommandEncoder(descriptor: rpd!)
            {
                renderEncoder.setRenderPipelineState(pipelineState!)
                renderEncoder.setVertexBuffer(obj.vertexBuffer,
                                              offset: 0,
                                              index: 0)
                renderEncoder.setVertexBuffer(obj.normalBuffer,
                                              offset: 0,
                                              index: 1)
                renderEncoder.setVertexBuffer(renderParams,
                                              offset: 0,
                                              index: 2)
                renderEncoder.drawPrimitives(type: .point,
                                             vertexStart: 0,
                                             vertexCount: obj.vertexCount!)
                
                renderEncoder.endEncoding()
                
                commandBuffer.present(drawable)
                commandBuffer.commit()
            }
        }
    }
    
    func updateUIView(_ uiView: UIViewType,
                      context: UIViewRepresentableContext<MetalView>)
    { }
}
