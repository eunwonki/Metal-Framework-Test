//
//  ViewController.swift
//  MetalRender
//
//  Created by skia on 2022/01/13.
//

import AVFoundation
import MetalKit
import UIKit

struct MTKMeshObj {
    var vertexCount: Int?
    var vertexBuffer: MTLBuffer?
    var normalBuffer: MTLBuffer?
    var triangleBuffer: MTLBuffer?
}

class ViewController: UIViewController {
    @IBOutlet var frameView: UIImageView!
    @IBOutlet var mtkView: MTKView!

    // device
//    let session = AVCaptureSession()
//    let sessionQueue = DispatchQueue(label: "com.raywenderlich.SessionQ")
//    let videoOutput = AVCaptureVideoDataOutput()
//    let videoOutputQueue = DispatchQueue(
//      label: "com.raywenderlich.VideoOutputQ",
//      qos: .userInitiated,
//      attributes: [],
//      autoreleaseFrequency: .workItem)
    
    // metal
    var metalDevice: MTLDevice!
    var metalCommandQueue: MTLCommandQueue!
    var pipelineState: MTLRenderPipelineState!
    
    var obj: MTKMeshObj!
    var renderParams: MTLBuffer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

//        #if targetEnvironment(simulator)
//        frameView.isHidden = true
//        #else
//        checkPermissions()
//        sessionQueue.async {
//            self.configureCaptureSession()
//            self.session.startRunning()
//        }
//        #endif
        
        initMetal()
        mtkView.delegate = self
    }
}
