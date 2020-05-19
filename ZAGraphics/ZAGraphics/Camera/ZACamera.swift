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

protocol ZACameraDelegte: AnyObject {
    
    func camera(_ camera: ZACamera, didOutput metadataObjects: [AVMetadataObject])
}

extension ZACameraDelegte {
    /// Implement defaul to make this function to optional
    func camera(_ camera: ZACamera, didOutput metadataObjects: [AVMetadataObject]) { }
}

class ZACamera: NSObject {
    
    /// This camera connect to real camera on device
    
    var captureSession: AVCaptureSession?

    var camera: AVCaptureDevice!
    
    var position: ZACameraPosition!
    
    var cameraInput: AVCaptureDeviceInput!
    
    var flashMode = AVCaptureDevice.FlashMode.off
    
    let cameraProcessingQueue = DispatchQueue.global()
    
    let cameraFrameProessingQueue = DispatchQueue(label: "ZA.frameProcessingQueue")
    
    var preset: AVCaptureSession.Preset!
    
    /// Output
    var videoOutput: AVCaptureVideoDataOutput!
    
    var captureConnection: AVCaptureConnection!
    
    /// Read/wrire direct on GPU, manage texture
    var videoTextureCache: CVMetalTextureCache?
    
    var consumers: [ImageConsumer]
    
    /// Zoom process
    let minimumZoom: CGFloat = 1.0
    
    let maximumZoom: CGFloat = 5.0
    
    var zoomFactor: CGFloat = 1.0
    
    var preZoomFactor: CGFloat = 1.0
    
    /// Using for face detect
    private var metadataOutput: AVCaptureMetadataOutput!
    
    private var metadataOutputQueue: DispatchQueue!
    
    /// Delegate
    public weak var delegate: ZACameraDelegte?
    
    ///temp
    var photoOutput: AVCapturePhotoOutput!
    
    var preview: AVCaptureVideoPreviewLayer!
    
    init(preset: AVCaptureSession.Preset = .hd1280x720, device: AVCaptureDevice? = nil, position: ZACameraPosition = .rear) throws {
        consumers = []
        captureSession = AVCaptureSession()
        super.init()
        self.position = position
        self.camera = device
        self.preset = preset
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
        
        /// This function not support simulator
        CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, sharedRenderer.device, nil, &videoTextureCache)
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
        
        if device == nil {
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
        photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])],
                                                  completionHandler: nil)
        
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
        
        try setupCameraInput(device: nil)
        
        let connection = videoOutput.connection(with: .video)

        if connection?.isVideoMirroringSupported ?? false {
            connection?.isVideoMirrored = position == ZACameraPosition.front ? true : false
        }
        if connection?.isVideoOrientationSupported ?? false {
            connection?.videoOrientation = .portrait
        }

        captureSession?.commitConfiguration()
    }
    
    public func addMetadataOutput(with types: [AVMetadataObject.ObjectType]) {

        guard let session = captureSession, metadataOutput == nil else {
            return
        }
        
        session.beginConfiguration()
        
        let output = AVCaptureMetadataOutput()
        let outputQueue = DispatchQueue(label: "phucnh7.vng.com.ZACamera.metadataOutput")
        output.setMetadataObjectsDelegate(self, queue: outputQueue)
        
        if session.canAddOutput(output) {
            session.addOutput(output)
            let validTypes = types.filter { output.availableMetadataObjectTypes.contains($0) }
            output.metadataObjectTypes = validTypes
            metadataOutput = output
            metadataOutputQueue = outputQueue
        }
        
        session.commitConfiguration()
    }
    
    func focus(at point: CGPoint) {
        do {
            try camera.lockForConfiguration()

            camera.focusPointOfInterest = point
            camera.focusMode = .autoFocus //.locked | .continuousAutoFocus
            camera.exposurePointOfInterest = point
            camera.exposureMode = .autoExpose
            camera.unlockForConfiguration()
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    func resetZoom(factor scale: CGFloat) {
        preZoomFactor *= scale
    }
    
    func zoom(factor scale: CGFloat) {
        zoomFactor = max(min(maximumZoom, scale * preZoomFactor), minimumZoom)
        do {
            try camera.lockForConfiguration()
            camera.videoZoomFactor = zoomFactor
            camera.unlockForConfiguration()
        } catch {
            print("\(error.localizedDescription)")
        }
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
    
        //let time = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        
        //lock de dam bao co the truy cap duoc
        //CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue:CVOptionFlags(0)))
        
        cameraFrameProessingQueue.async {
            var textureRef: CVMetalTexture? = nil
            CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                      self.videoTextureCache!,
                                                      imageBuffer,
                                                      nil,
                                                      .bgra8Unorm,
                                                      width,
                                                      height,
                                                      0,
                                                      &textureRef)
            
            var texture: ZATexture? = nil
            if let checkedTexture = textureRef, let mtlTexture = CVMetalTextureGetTexture(checkedTexture) {
                texture = ZATexture(texture: mtlTexture)
            } else {
                texture = nil
            }
            
            if let text = texture {
                for consumer in self.consumers {
                    consumer.newTextureAvailable(text,from: self)
                }
            }
        }
        
    }
}

// MARK: image source protocol
extension ZACamera: ImageSource { }

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

// MARK: metaDada extension
extension ZACamera: AVCaptureMetadataOutputObjectsDelegate {
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let delegate = self.delegate {
            delegate.camera(self, didOutput: metadataObjects)
        }
    }
}
