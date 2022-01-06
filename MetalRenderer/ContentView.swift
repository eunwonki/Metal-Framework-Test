//
//  ContentView.swift
//  MetalRenderer
//
//  Created by skia on 2022/01/06.
//

import SwiftUI
import MetalKit

struct ContentView: View {
#if !targetEnvironment(simulator)
    @StateObject private var model = ContentViewModel()
#endif
    
    static let frameIpad11 = CGRect(x: 0, y: 0, width: 1194, height: 834)
    private var metalView = MetalView(mtkView: MTKView(frame: frameIpad11))

    var body: some View {
        let drag = DragGesture()
            .onChanged {
                metalView.onDrag(start: $0.startLocation,
                                 translation: $0.translation)
            }
        
        ZStack{
            #if !targetEnvironment(simulator)
            FrameView(image: model.frame)
            #endif
            metalView
                .gesture(drag)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
