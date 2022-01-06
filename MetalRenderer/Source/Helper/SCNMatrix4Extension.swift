//
//  SCNMatrix4.swift
//  MetalRenderer
//
//  Created by skia on 2022/01/13.
//

import SceneKit

extension SCNMatrix4{
    var matrix: [Float] {
        [m11, m21, m31, m41,
         m12, m22, m32, m42,
         m13, m23, m33, m43,
         m14, m24, m34, m44]
    }
    
    var matrix2: [Float] {
        [m11, m12, m13, m14,
         m21, m22, m23, m24,
         m31, m32, m33, m34,
         m41, m42, m43, m44]
    }
}

public func * (left: SCNMatrix4, right: SCNMatrix4) -> SCNMatrix4 {
    return SCNMatrix4Mult(left, right)
}
