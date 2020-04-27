//
//  ZACamera.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/20/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import AVFoundation
import UIKit
import Metal

class ZACamera: NSObject {
    /**
     this is camera connect to real camera on device
     */
    
    var captureSession: AVCaptureSession?
    
    var camera: AVCaptureDevice!
    
    var position: ZACameraPosition!
    
    var cameraInput: AVCaptureDeviceInput!
    
    var flashMode = AVCaptureDevice.FlashMode.off
    
    let cameraProcessingQueue = DispatchQueue.global()
    
    let cameraFrameProessingQueue = DispatchQueue(label: "ZA.frameProcessingQueue")
    
    var preset: AVCaptureSession.Preset!
    
    ///output
    var videoOutput: AVCaptureVideoDataOutput!
    ///su dung de truc tiep doc/ghi GPU
    var videoTextureCache: CVMetalTextureCache?
    
    //temp
    var photoOutput: AVCapturePhotoOutput!
    
    var preview: AVCaptureVideoPreviewLayer!
    
    init(preset: AVCaptureSession.Preset, device: AVCaptureDevice? = nil, position: ZACameraPosition = .rear) throws {
        super.init()
        self.position = position
        self.camera = device
        self.preset = preset
        captureSession = AVCaptureSession()
    }
    
    func setup() throws {
        guard let captureSession = self.captureSession else {
                 throw ZACameraError.captureSessionMissing
             }
             
             captureSession.beginConfiguration()
             if captureSession.canSetSessionPreset(preset) {
                 captureSession.sessionPreset = preset
             }
        
        try setupCameraInput(device: self.camera)
             try setupVideoOutput()
             //try setupPhotoOutput()
             
             captureSession.commitConfiguration()
             
             CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, Renderer.device, nil, &videoTextureCache)
    }
    
    deinit {
        cameraFrameProessingQueue.sync {
            self.stopCapture()
            self.videoOutput.setSampleBufferDelegate(nil, queue: nil)
        }
    }
    
    func setupCameraInput(device: AVCaptureDevice?) throws {
        guard let captureSession = self.captureSession else {
            throw ZACameraError.captureSessionMissing
        }
        
        if camera == nil {
            try self.camera = position.device()
        }
        
        cameraInput = try AVCaptureDeviceInput(device: self.camera)

        if captureSession.canAddInput(self.cameraInput) {
            captureSession.addInput(self.cameraInput)
        }
    }
    
    func setupVideoOutput() throws {
        guard let captureSession = self.captureSession else {
            throw ZACameraError.captureSessionMissing
        }
        
        videoOutput = AVCaptureVideoDataOutput()
        videoOutput.alwaysDiscardsLateVideoFrames = false

        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String:NSNumber(value:Int32(kCVPixelFormatType_32BGRA))]
        
        let connection = videoOutput.connection(with: .video)
        
        if connection?.isVideoMirroringSupported ?? false {
            connection?.isVideoMirrored = false
        }
        if connection?.isVideoOrientationSupported ?? false {
            connection?.videoOrientation = .portrait
        }
        
        videoOutput.setSampleBufferDelegate(self, queue: cameraProcessingQueue)
        

    }
    
    func setupPhotoOutput() throws {
        guard let captureSession = self.captureSession else {
            throw ZACameraError.captureSessionMissing
        }
        
        photoOutput = AVCapturePhotoOutput()
        photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
    }
    
    func authorizationStatus() -> ZAAuthorizationStatus {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return .authorized
            
        case .notDetermined:
            return .notDetermined
            
        case .denied:
            return .denied
            
        case .restricted:
            return .restricted
        }
    }
    
    func requestAccess(handle: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            handle(granted)
        }
    }
    
    func startCapture() {
        if !(captureSession?.isRunning ?? false) {
            captureSession?.startRunning()
        }
    }
    
    func stopCapture() {
        if captureSession?.isRunning ?? false {
            captureSession?.stopRunning()
        }
    }
    
    func switchCamera() throws {
        guard let session = self.captureSession, session.isRunning else {
            throw ZACameraError.captureSessionMissing
        }
        
        captureSession?.beginConfiguration()
        captureSession?.removeInput(cameraInput)
        if position == .front {
            position = .rear
        } else {
            position = .front
        }
        
        do {
            try setupCameraInput(device: nil)
        } catch let e {
            throw e
        }
        
        captureSession?.commitConfiguration()
    }
    
    func preview(on view: UIView) throws {
        guard let captureSession = self.captureSession, captureSession.isRunning else {
            throw ZACameraError.captureSessionMissing
        }
        
        preview = AVCaptureVideoPreviewLayer(session: captureSession)
        preview.videoGravity = .resizeAspectFill
        preview.connection?.videoOrientation = .portrait
        view.layer.insertSublayer(preview, at: 0)
        preview.frame = view.bounds
    }
}

// MARK: video output delegate
extension ZACamera: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        let time = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        
        //lock de dam bao co the truy cap duoc
        //CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue:CVOptionFlags(0)))
        
        cameraFrameProessingQueue.async {
            var textureRef: CVMetalTexture? = nil
            CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, self.videoTextureCache!, imageBuffer, nil, .bgra8Unorm, width, height, 0, &textureRef)
            
            var texture: ZATexture? = nil
            if let checkedTexture = textureRef, let mtlTexture = CVMetalTextureGetTexture(checkedTexture) {
                texture = ZATexture(texture: mtlTexture)
            } else {
                texture = nil
            }
            
            if let text = texture {
                //sharedInversion.newTextureAvailable(text)
                sharedSketch.newTextureAvailable(text)
            }
        }
        
    }
}

// MARK: enum extension
extension ZACamera {
        
    enum ZACameraError: Error {
        
        case captureSessionRuning
        
        case captureSessionMissing
        
        case inputInvalid
        
        case noCameraAvailable
        
        case unknown
    }
    
    enum ZAAuthorizationStatus: Int {
        
        case restricted = 0 // The user can't grant access due to restrictions.
        
        case denied = 1 // The user has previously denied access.
        
        case authorized = 2 // The user has previously granted access to the camera.
        
        case notDetermined = 3 // The user has not yet been asked for camera access.
    }
    
    enum ZACameraPosition {
        
        case front
        
        case rear
        
        func position() -> AVCaptureDevice.Position {
            switch self {
            case .front:
                return.front
            case .rear:
                return .back
            }
        }
        
        func device() throws -> AVCaptureDevice {
            var device: AVCaptureDevice!
            let session =  AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
            
            let cameras = (session.devices.compactMap({$0}))
            guard !cameras.isEmpty else {
                throw ZACameraError.noCameraAvailable
            }
            
            for camera in cameras {
                if camera.position == self.position() {
                    device = camera
                }
            }
            
            try device.lockForConfiguration()
            if device.isFocusModeSupported(.autoFocus) {
                device.focusMode = .autoFocus
            }
            device.unlockForConfiguration()
            
            return device
        }
    }
}
