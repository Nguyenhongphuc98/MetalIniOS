//
//  ZACamera.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/20/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import AVFoundation
import UIKit

class ZACamera: NSObject {
    /**
     this is camera connect to real camera on device
     */
    
    var captureSession: AVCaptureSession?
    
    var camera: AVCaptureDevice!
    
    var position: ZACameraPosition!
    
    var cameraInput: AVCaptureDeviceInput!
    
    var flashMode = AVCaptureDevice.FlashMode.off
    
    //temp
    var photoOutput: AVCapturePhotoOutput!
    
    var preview: AVCaptureVideoPreviewLayer!
    
    init(preset: AVCaptureSession.Preset, device: AVCaptureDevice? = nil, position: ZACameraPosition = .rear) throws {
        super.init()
        self.position = position
        captureSession = AVCaptureSession()
        
        guard let captureSession = self.captureSession else {
            throw ZaCameraError.captureSessionMissing
        }
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = preset
        
        do {
            try setupCameraInput(device: device)
        } catch let e {
            throw e
        }
        
        photoOutput = AVCapturePhotoOutput()
        photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
        
        captureSession.commitConfiguration()
    }
    
    func setupCameraInput(device: AVCaptureDevice?) throws {
        guard let captureSession = self.captureSession else {
            throw ZaCameraError.captureSessionMissing
        }
        
        if let camera = device {
            self.camera = camera
        } else {
            do {
                try self.camera = position.device()
            } catch let e {
                throw e
            }
        }
        
        do {
            cameraInput = try AVCaptureDeviceInput(device: self.camera)
        } catch let e {
            throw e
        }
        
        if captureSession.canAddInput(self.cameraInput) {
            captureSession.addInput(self.cameraInput)
        }
    }
    
    func startCapture() {
        if !(captureSession?.isRunning ?? false) {
            captureSession?.startRunning()
        }
    }
    
    func stopCapture() {
        if !(captureSession?.isRunning ?? false) {
            captureSession?.stopRunning()
        }
    }
    
    func switchCamera() throws {
        guard let session = self.captureSession, session.isRunning else {
            throw ZaCameraError.captureSessionMissing
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
            throw ZaCameraError.captureSessionMissing
        }
        
        preview = AVCaptureVideoPreviewLayer(session: captureSession)
        preview.videoGravity = .resizeAspectFill
        preview.connection?.videoOrientation = .portrait
        view.layer.insertSublayer(preview, at: 0)
        preview.frame = view.bounds
    }
}

// MARK: enum extension
extension ZACamera {
        
    enum ZaCameraError: Error {
        case captureSessionRuning
        case captureSessionMissing
        case inputInvalid
        case noCameraAvailable
        case unknown
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
                throw ZaCameraError.noCameraAvailable
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
