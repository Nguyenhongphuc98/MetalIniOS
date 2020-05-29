//
//  ZAVideoSource.swift
//  ZAGraphics
//
//  Created by phucnh7 on 5/28/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import AVFoundation

class ZAVideoSource {
    
    /// Abstract class used ti model timed
    private var asset: AVAsset!
    
    /// Used to obtain the media data
    private var assetReader: AVAssetReader!
    
    /// Used to reading single track of asset reader
    private var videoOutput: AVAssetReaderTrackOutput!
    
    /// Manage texture and can directly read from or write to GPU base core video
    private var textureCache: CVMetalTextureCache!
    
    /// Lovation of video need to read
    private var url: URL
    
    private var isUseVideoFrameRate: Bool
    
    /// Image source protocol
    internal var consumers: [ImageConsumer] = []
    
    init?(url: URL, useVideoFrameRate: Bool = true) {
        self.url = url
        self.isUseVideoFrameRate = useVideoFrameRate
        
        if CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, sharedRenderer.device, nil, &textureCache) != kCVReturnSuccess {
            return nil
        }
    }
    
    private func reset() {
        asset = nil
        assetReader = nil
        videoOutput = nil
    }
    
    public func startRead() {
        if assetReader != nil {
            print("Video reader is reading, try later...")
            return
        }
        
        let asset = AVAsset(url: url)
        asset.loadValuesAsynchronously(forKeys: ["tracks"]) { [weak self] in
            
            guard let self = self else { return }
            
            if asset.statusOfValue(forKey: "tracks", error: nil) == .loaded, asset.tracks(withMediaType: .video).first != nil {
                self.asset = asset
                if self.prepareAssetReader() {
                    self.readAsset()
                } else {
                    self.reset()
                }
            }
        }
    }
    
    public func cancelRead() {
        if let reader = assetReader {
            reader.cancelReading()
            reset()
        }
    }
    
    private func prepareAssetReader() -> Bool {
        guard let reader = try? AVAssetReader(asset: asset),
            let video = asset.tracks(withMediaType: .video).first else { return false}
        
        assetReader = reader
        videoOutput = AVAssetReaderTrackOutput(track: video, outputSettings: [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA])
        
        // Bot copies make buffer may still ref by other entities
        // Because we just read, not modify any thing so let fase value make lead to perfomance
        // (Theo apple docs :v)
        videoOutput.alwaysCopiesSampleData = false
        
        if assetReader.canAdd(videoOutput) {
            assetReader.add(videoOutput)
        } else {
            return false
        }
        
        return true
    }
    
    private func readAsset() {
        guard let reader = assetReader, reader.status == .unknown, reader.startReading() else {
            reset()
            return
        }
        
        var lastSampleFrameTime: CMTime!
        var lastActualPlayTime: Double = 0
        var sleepTime: Double = 0
        var sampleFrameTime: CMTime
        
        let startTime = CACurrentMediaTime()
        var count: Int = 0
        while assetReader.status == .reading, let buffer = videoOutput.copyNextSampleBuffer() {
            guard let imageBuffer = CMSampleBufferGetImageBuffer(buffer) else { continue }
            let w = CVPixelBufferGetWidth(imageBuffer)
            let h = CVPixelBufferGetHeight(imageBuffer)
            
            var metalTexture: CVMetalTexture?
            let result = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, textureCache, imageBuffer, nil, .bgra8Unorm, w, h, 0, &metalTexture)
            
            sampleFrameTime = CMSampleBufferGetOutputPresentationTimeStamp(buffer)
            
            if result == kCVReturnSuccess, let textureOut = metalTexture, let texture = CVMetalTextureGetTexture(textureOut) {
                let zaTexture = ZATexture(texture: texture, time: sampleFrameTime)
                
                /// Wait for correct frame if needed
//                if isUseVideoFrameRate {
//                    if let _ = lastSampleFrameTime {
//                        /// elapsed time expect
//                        let detalFrameTime = CMTimeGetSeconds(CMTimeSubtract(sampleFrameTime, lastSampleFrameTime))
//                        let detalPlayTime = CACurrentMediaTime() - lastActualPlayTime
//                        if detalFrameTime > detalPlayTime {
//                            sleepTime = detalFrameTime - detalPlayTime
//                            /// Take parameter millionths of a second
//                            usleep(UInt32(1000000 * sleepTime))
//                            //print("sleep: ",sleepTime)
//                        }
//                    }
//
//                    lastActualPlayTime = CACurrentMediaTime()
//                    lastSampleFrameTime = sampleFrameTime
//                }
                usleep(UInt32(1000000 * 0.02))
                
                for consumer in consumers {
                    consumer.newTextureAvailable(zaTexture, from: self)
                }
                
                print("count: ", count)
                count += 1
            }
        }
        
        print("total time:", CACurrentMediaTime() - startTime)
    }
}

extension ZAVideoSource: ImageSource {
    
}
