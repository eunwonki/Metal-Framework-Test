//
//  ContentView.swift
//  MetalRenderer
//
//  Created by skia on 2022/01/06.
//

import MetalKit
import SwiftUI

struct ContentView: View {
    #if !targetEnvironment(simulator)
        @StateObject private var model = ContentViewModel()
    #endif

    var body: some View {
        let magnification = MagnificationGesture()
            .onChanged {
                Gesture.OnZooming(magnitude: $0.magnitude)
            }
            .onEnded { _ in
                Gesture.OnZoomEnd()
            }

        let drag = DragGesture()
            .onChanged {
                Gesture.OnDragging(start: $0.startLocation,
                                   translation: $0.translation)
            }
            .onEnded { _ in
                Gesture.OnDragEnd()
            }

        ZStack {
            #if !targetEnvironment(simulator)
                FrameView(image: model.frame)
            #endif

            MetalView(mtkView: MTKView())
            #if os(iOS)
                .gesture(drag)
                .gesture(magnification)
            #endif
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
