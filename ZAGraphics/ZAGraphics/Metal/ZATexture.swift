//
//  ZATexture.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/22/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit
import CoreMedia

public class ZATexture: Textureable {
    
    /**
         Texture using for process video output
    */
    
    var texture: MTLTexture!
    
    var sampleTime: CMTime?
    
    
    init(image name: String) {
        self.texture = setTexture(device: sharedRenderer.device, image: name)
    }
    
    /// Should use when have a available MTLTexture, ex: from camera source
    init(texture: MTLTexture, time: CMTime?) {
        self.texture = texture
        self.sampleTime = time
    }
    
    /// Should use when need process new texture, ex: filter operation
    init(device: MTLDevice, texture: ZATexture) {
        sampleTime = texture.sampleTime
        let textureDes = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm,
                                                                  width: texture.width(),
                                                                  height: texture.height(),
                                                                  mipmapped: false)
        textureDes.usage = [.renderTarget, .shaderRead, .shaderWrite]
        
        guard let texture = sharedRenderer.device.makeTexture(descriptor: textureDes) else {
            fatalError("Could't make new Texture!")
        }
        
        self.texture = texture
    }
    
    func makeCGImage() -> CGImage {
        let size = texture.width * texture.height * 4
        let memory = UnsafeMutablePointer<UInt8>.allocate(capacity: size)
        texture.getBytes(memory,
                         bytesPerRow: MemoryLayout<UInt8>.size * texture.width * 4,
                         bytesPerImage: 0,
                         from: MTLRegionMake2D(0, 0, texture.width, texture.height),
                         mipmapLevel: 0,
                         slice : 0)
        
        guard let dataProvider = CGDataProvider(dataInfo: nil,
                                                data: memory,
                                                size: size,
                                                releaseData: { (context, data, size) in data.deallocate() }
            ) else { fatalError("Create CGDataProcider fail.") }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        //let colorSpace = CGColorSpace(name: CGColorSpace.extendedSRGB)!
    
        print("color space: \(colorSpace)")
        print("uint 8 size:: \(MemoryLayout<UInt8>.size)")
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let image = CGImage(width: texture.width,
                            height: texture.height,
                            bitsPerComponent: 8,
                            bitsPerPixel: 32,
                            bytesPerRow: texture.width * 4,
                            space: colorSpace,
                            bitmapInfo: bitmapInfo,
                            provider: dataProvider,
                            decode: nil,
                            shouldInterpolate: false,
                            intent: .defaultIntent)
        
        return image!
    }
    
    func makeCGImage2() -> CGImage? {
        
        let bytesPerPixel: Int = 4
        let bytesPerRow: Int = texture.width * bytesPerPixel
        
        
        var data = [UInt8](repeating: 0, count: Int(texture.width * texture.height * bytesPerPixel))
        texture.getBytes(&data, bytesPerRow: bytesPerRow, from: MTLRegionMake2D(0, 0, texture.width, texture.height), mipmapLevel: 0)
        let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue
        if let context = CGContext(data: &data,
                                   width: texture.width,
                                   height: texture.height,
                                   bitsPerComponent: 8,
                                   bytesPerRow: bytesPerRow,
                                   space: CGColorSpaceCreateDeviceRGB(),
                                   bitmapInfo: bitmapInfo) {
            return context.makeImage()
        }
        return nil
    }
    
    func makeCGImage3() -> CGImage {
        let context = CIContext()

        let cImg = CIImage(mtlTexture: texture, options: nil)!
        let cgImg = context.createCGImage(cImg, from: cImg.extent)!
        
        return cgImg
    }
}
