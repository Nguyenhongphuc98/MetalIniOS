//
//  ZAOperationHandle.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/29/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import Metal

infix operator +> : AdditionPrecedence
@discardableResult public func +><T: ImageConsumer>(source: ImageSource, consumer: T) -> T {
    return source.add(consumer: consumer)
}

/// Using to break ref source <--> consumer
public struct ZAWeakImageSource {
    
    public weak var source: ImageSource?
    
    public var texture: MTLTexture?
    
    public init(source: ImageSource) {
        self.source = source
    }
}

/// Define behaviors of image provider (source)
public protocol ImageSource: AnyObject {
    
    var consumers: [ImageConsumer] { get set }
    
    /// Add an image consumer to consume output (texture)
    func add<T:ImageConsumer>(consumer: T) -> T
    
    /// Remove image consumer
    func remove(consumer: ImageConsumer)
    
    /// Remove all image consumer
    func clear()
}

extension ImageSource {
    
    public func add<T>(consumer: T) -> T where T : ImageConsumer {
        consumers.append(consumer)
        consumer.add(source: self)
        return consumer
    }
    
    public func remove(consumer: ImageConsumer) {
        guard let index = consumers.firstIndex(where: { $0 === consumer }) else {
            return
        }
        consumers.remove(at: index)
        consumer.remove(source: self)
    }
    
    public func clear() {
        for consumer in consumers {
            consumer.remove(source: self)
        }
        consumers.removeAll()
    }
}

/// Define behaviors of image consumer  (ex: metalview)
public protocol ImageConsumer: AnyObject {
    
    var sources: [ZAWeakImageSource] { get set }
    
    /// Add provider to get texture
    func add(source: ImageSource)
    
    /// Remove provider (image source)
    func remove(source: ImageSource)
    
    /// Receive new texture from source
    func newTextureAvailable(_ texture: ZATexture, from source: ImageSource)
}

extension ImageConsumer {
    
    public func add(source: ImageSource) {
        sources.append(ZAWeakImageSource(source: source))
    }
    
    public func remove(source: ImageSource) {
        if let index = sources.firstIndex(where: { $0.source === source }) {
            sources.remove(at: index)
        }
    }
}
