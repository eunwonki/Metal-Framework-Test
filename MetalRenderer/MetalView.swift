//
//  MetalView.swift
//  MetalRenderer
//
//  Created by skia on 2022/01/06.
//

import MetalKit
import SwiftUI

// TODO: List
// 1. rendering color frame
// 2. rendering wireframe
// 3. rendering pointcloud
// 3. rendering mesh
// 4. simple camera controller

struct MetalView: UIViewRepresentable {
    typealias UIViewType = MTKView
    var mtkView: MTKView
    
    class Coordinator: Renderer {}
    
    func updateUIView(_ uiView: UIViewType,
                      context: UIViewRepresentableContext<MetalView>)
    { }

    func makeCoordinator() -> Coordinator {
        mtkView.device = MTLCreateSystemDefaultDevice()
        Engine.Ignite(device: mtkView.device!)
        mtkView.clearColor = Preferences.ClearColor
        mtkView.colorPixelFormat = Preferences.MainPixelFormat
        mtkView.depthStencilPixelFormat = Preferences.MainDepthPixelFormat
        mtkView.backgroundColor = .clear
        return Coordinator(mtkView)
    }

    func makeUIView(context: Context) -> MTKView {
        mtkView.delegate = context.coordinator
        return mtkView
    }

    func onDrag(start: CGPoint, translation: CGSize) {
//        let scrollWidthRatio = Float(translation.width) / 10000 * -1
//        let scrollHeightRatio = Float(translation.height) / 10000
//        camNode.eulerAngles.y += Float(-2 * Double.pi) * scrollWidthRatio
//        camNode.eulerAngles.x += Float(-Double.pi) * scrollHeightRatio
        mtkView.draw()
    }
}
