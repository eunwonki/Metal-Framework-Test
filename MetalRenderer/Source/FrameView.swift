//
//  FrameView.swift
//  MetalRenderer
//
//  Created by skia on 2022/01/06.
//

import SwiftUI

struct FrameView: View {
    var image: CGImage?

    var body: some View {
        if let image = image {
            GeometryReader {
                geometry in
                Image(image, scale: 1.0,
                      orientation: .rightMirrored,
                      label: Text(""))
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height,
                        alignment: .center)
                    .clipped()
            }
        } else {
            EmptyView()
        }
    }
}
