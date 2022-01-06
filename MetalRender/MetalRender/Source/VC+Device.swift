////
////  FrameView.swift
////  MetalRenderer
////
////  Created by skia on 2022/01/06.
////
//
//import AVFoundation
//import UIKit
//
//extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
//    func captureOutput(
//        _ output: AVCaptureOutput,
//        didOutput sampleBuffer: CMSampleBuffer,
//        from connection: AVCaptureConnection
//    ) {
//        if let buffer = sampleBuffer.imageBuffer {
//            DispatchQueue.main.async {
//                if let cgimage = CGImage.create(from: buffer) {
//                    let uiimage = UIImage(cgImage: cgimage, scale: 1.0, orientation: .rightMirrored)
//                    self.frameView.image = uiimage
//                } else {
//                    self.frameView.image = UIImage()
//                }
//            }
//        }
//    }
//
//    func checkPermissions() {
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .notDetermined:
//            sessionQueue.suspend()
//            AVCaptureDevice.requestAccess(for: .video) { authorized in
//                if !authorized {
//                    NSLog("permission not authorizaed")
//                }
//                self.sessionQueue.resume()
//            }
//        case .restricted:
//            NSLog("permission restricted")
//        case .denied:
//            NSLog("permission denied")
//        case .authorized:
//            break
//        @unknown default:
//            fatalError("unknown state")
//        }
//    }
//
//    func configureCaptureSession() {
//        session.beginConfiguration()
//
//        defer {
//            session.commitConfiguration()
//        }
//
//        let device = AVCaptureDevice.default(
//            .builtInWideAngleCamera,
//            for: .video,
//            position: .back
//        )
//        guard let camera = device else {
//            return
//        }
//
//        do {
//            let cameraInput = try AVCaptureDeviceInput(device: camera)
//            if session.canAddInput(cameraInput) {
//                session.addInput(cameraInput)
//            } else {
//                fatalError("fail")
//            }
//        } catch {
//            fatalError("fail")
//        }
//
//        if session.canAddOutput(videoOutput) {
//            session.addOutput(videoOutput)
//
//            videoOutput.videoSettings =
//                [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
//
//            let videoConnection = videoOutput.connection(with: .video)
//            videoConnection?.videoOrientation = .portrait
//        } else {
//            fatalError("fail")
//        }
//
//        sessionQueue.async {
//            self.videoOutput.setSampleBufferDelegate(self, queue: self.videoOutputQueue)
//        }
//    }
//}
