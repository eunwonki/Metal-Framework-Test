//
//  MetalView.swift
//  MetalRenderer
//
//  Created by skia on 2022/01/06.
//

import Foundation
import MetalKit
import SceneKit
import SwiftUI

// TODO: List
// 1. rendering color frame (half completed)
// 2. rendering wireframe (with camera)
// 3. rendering pointcloud (with camera)
// 3. rendering mesh (with camera)
// 4. simple camera controller (orbit)

struct MetalView: UIViewRepresentable {
    typealias UIViewType = MTKView
    var mtkView: MTKView

    var camNode = SCNNode()
    let cameraOrbit = SCNNode()

    func makeCoordinator() -> Coordinator {
        Coordinator(self, mtkView: mtkView)
    }

    func makeUIView(context: Context) -> MTKView {
        mtkView.delegate = context.coordinator
        mtkView.preferredFramesPerSecond = 60
        mtkView.backgroundColor = .clear
        mtkView.isOpaque = false
        mtkView.enableSetNeedsDisplay = true
        return mtkView
    }

    func setupCamera(lookAt: SCNVector3) {
        let camera = SCNCamera()
        camera.zNear = 0.1
        camera.zFar = 0.2

        camNode.camera = camera
        camNode.position = SCNVector3Make(0, 0, -5)
        camNode.look(at: lookAt)

        cameraOrbit.addChildNode(camNode)
    }

    func onDrag(start: CGPoint, translation: CGSize) {
        let scrollWidthRatio = Float(translation.width) / 10000 * -1
        let scrollHeightRatio = Float(translation.height) / 10000
        camNode.eulerAngles.y += Float(-2 * Double.pi) * scrollWidthRatio
        camNode.eulerAngles.x += Float(-Double.pi) * scrollHeightRatio
        mtkView.draw()
    }
}
