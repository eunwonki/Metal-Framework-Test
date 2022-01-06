//
//  ViewController+Metal.swift
//  MetalRender
//
//  Created by skia on 2022/01/13.
//

import MetalKit

extension ViewController: MTKViewDelegate {
    func initMetal() {
        mtkView.preferredFramesPerSecond = 60
        mtkView.backgroundColor = .clear
        mtkView.isOpaque = false
        mtkView.enableSetNeedsDisplay = true
        
        mtkView.device = MTLCreateSystemDefaultDevice()!
        metalDevice = mtkView.device!
        
        metalCommandQueue = metalDevice.makeCommandQueue()!
        
        mtkView.framebufferOnly = false
        mtkView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        mtkView.drawableSize = mtkView.frame.size
        mtkView.enableSetNeedsDisplay = true
        
//        obj = read()
//
//        let defaultLibrary = metalDevice!.makeDefaultLibrary()!
//        let fragmentProgram = defaultLibrary.makeFunction(name: "frag")
//        let vertexProgram = defaultLibrary.makeFunction(name: "vert")
//
//        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
//        pipelineStateDescriptor.vertexFunction = vertexProgram
//        pipelineStateDescriptor.fragmentFunction = fragmentProgram
//        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm

//        self.pipelineState = try! metalDevice!.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
    }
    
    func read() -> MTKMeshObj {
        var obj = MTKMeshObj()
        
        let url = Bundle.main.url(forResource: "scene", withExtension: "obj")!
        let mesh = MDLAsset(url: url).object(at: 0) as! MDLMesh
        
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
        NSLog("draw (\(view.frame)")
    }
}
