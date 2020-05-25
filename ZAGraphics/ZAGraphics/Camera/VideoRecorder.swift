//
//  VideoRecorder.swift
//  ZAGraphics
//
//  Created by phucnh7 on 5/21/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import AVFoundation
import Photos

func defaultOutPutVideoPath() -> URL {
//    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//    let fullPath = path + "/\(Date().timeIntervalSince1970).mp4"
    let fullPath = NSTemporaryDirectory() + "\(Date().timeIntervalSince1970).mp4"
    return URL(fileURLWithPath: fullPath)
}

class VideoRecorder {
    
    private var assetWriter: AVAssetWriter!
    
    private var assetWriterVideoInput: AVAssetWriterInput!
    
    private var assetWriterPixelBufferInput: AVAssetWriterInputPixelBufferAdaptor!
    
    private var pixelBuffer: CVPixelBuffer!
    
    private var startTime: CMTime!
    
    public var isRecording = false
    
    public let url: URL
    
    public let videoSize: CGSize
    
    public let videoType: AVFileType
    
    public var outputSettings: [String : Any]
    
    public var timeRecordDidChange: ((_ timeElapsed: UInt) -> Void)?
    
    /// Image consumer protocol
    public var sources: [ZAWeakImageSource] = []
    
    public init(url: URL = defaultOutPutVideoPath(),
                type: AVFileType = .mp4,
                size: CGSize,
                outputSettings: [String : Any] = [AVVideoCodecKey : AVVideoCodecType.h264]) {
        
        self.url = url
        self.videoType = type
        self.videoSize = size
        self.outputSettings = outputSettings
    }
    
    public func prepareWriter() -> Bool {
        guard let writer = try? AVAssetWriter(url: url, fileType: videoType) else {
            return false
        }
        
        outputSettings[AVVideoWidthKey] = videoSize.width
        outputSettings[AVVideoHeightKey] = videoSize.height
        
        assetWriterVideoInput = AVAssetWriterInput(mediaType: .video, outputSettings: outputSettings)
        assetWriterVideoInput.expectsMediaDataInRealTime = true
        
        guard writer.canAdd(assetWriterVideoInput) else {
            return false
        }
        
        writer.add(assetWriterVideoInput)
        assetWriter = writer
        
        let bufferAttributes: [String : Any] = [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA,
                                                kCVPixelBufferWidthKey as String : videoSize.width,
                                                kCVPixelBufferHeightKey as String : videoSize.height]
        
        assetWriterPixelBufferInput = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: assetWriterVideoInput,
                                                                           sourcePixelBufferAttributes: bufferAttributes)
        return true
    }
    
    func startRecord() {
        if assetWriter == nil {
            let result = prepareWriter()
            assert(result, "fail to setup writer")
        }
        
        let started = assetWriter.startWriting()
        assert(started, "can't start writing")
        isRecording = true
    }
    
    func stopRecord(saveToLib: Bool, completionHandler: ((_ url: URL?) -> Void)?) {
        isRecording = false
        
        guard let input = self.assetWriterVideoInput, let writer = self.assetWriter , writer.status == .writing else {
            assert(false, "writer isn't writing or object not fully setup")
        }
        
        input.markAsFinished()
        writer.finishWriting(completionHandler: {
            if saveToLib {
                self.saveVideoToPhotoLib(url: self.url)
                 completionHandler?(nil)
            } else {
                completionHandler?(self.url)
            }
            
            self.reset()
        })
    }
    
    func cancelRecord() {
        guard let input = self.assetWriterVideoInput, let writer = self.assetWriter , writer.status == .writing else {
            assert(false, "writer isn't writing or object not fully setup")
        }
        
        isRecording = false
        input.markAsFinished()
        writer.cancelWriting()
        reset()
    }
    
    private func reset() {
        /// Theo apple docs :v
        /// You can only use a given instance of AVAssetWriter once to write to a single file.
        /// You must use a new instance of AVAssetWriter every time you write to a file
        assetWriter = nil
        assetWriterVideoInput = nil
        pixelBuffer = nil
        assetWriterPixelBufferInput = nil
    }
    
    func saveVideoToPhotoLib(url: URL) {
       
        func save(url: URL) {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            }) { (isSaved, error) in
                
                if isSaved {
                    print("video was saved")
                } else {
                    print("something wrong when save video")
                }
                
                //if saved, clear data in temporary
                self.removeVideo(at: url)
            }
        }
        
        requestAccessPhotoLib { (authorized) in
            if authorized {
                save(url: url)
            } else { print("fail to save video")  }
        }
    }
    
    func requestAccessPhotoLib(completeHandle: @escaping(_ authorized: Bool) -> ()) {
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            completeHandle(true)
        } else {
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    completeHandle(true)
                } else {
                    completeHandle(false)
                }
            }
        }
    }
    
    func removeVideo(at url:URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("error")
        }
    }
}

extension VideoRecorder: ImageConsumer {
    
//    func add(source: ImageSource) { }
//    
//    func remove(source: ImageSource) { }
    
    func newTextureAvailable(_ texture: ZATexture, from source: ImageSource) {
        
        guard let time = texture.sampleTime,
            let writer = self.assetWriter,
            let input = self.assetWriterVideoInput,
            let buffer = self.assetWriterPixelBufferInput,
            writer.status == .writing else {
                return
        }
        
        if pixelBuffer == nil {
            /// Real start recording time
            writer.startSession(atSourceTime: time)
            startTime = texture.sampleTime
            
            guard let bufferPool = buffer.pixelBufferPool,
            CVPixelBufferPoolCreatePixelBuffer(nil, bufferPool, &pixelBuffer) == kCVReturnSuccess else {
                return
            }
        }
        
        /// Drop this frame, if wanto wait, maybe let it in while statement :v
        guard input.isReadyForMoreMediaData, writer.status == .writing else {
            return
        }
        
        /// Get data from texture to buffer
        guard pixelBuffer != nil,
        CVPixelBufferLockBaseAddress(pixelBuffer, []) == kCVReturnSuccess else {
            return
        }
        
        guard let baseAdress = CVPixelBufferGetBaseAddress(pixelBuffer) else {
            CVPixelBufferUnlockBaseAddress(pixelBuffer, [])
            return
        }
        
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let region = MTLRegionMake2D(0, 0, texture.width(), texture.height())
        
        texture.texture.getBytes(baseAdress, bytesPerRow: bytesPerRow, from: region, mipmapLevel: 0)
        buffer.append(pixelBuffer, withPresentationTime: time)
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer, [])
        
        if let timeChanged = self.timeRecordDidChange {
            let elapsed = texture.sampleTime! - self.startTime
            timeChanged(UInt(CMTimeGetSeconds(elapsed)))
        }
    }
}
