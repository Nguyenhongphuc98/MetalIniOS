//
//  ZAOperationHandle.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/29/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import Foundation

infix operator +>: AdditionPrecedence
@discardableResult public func +><T: ImageConsumer>(source: ImageSource, consumer: T) -> T {
    return source.add(consumer: consumer)
}

/// Define behaviors of image provider (source)
public protocol ImageSource: AnyObject {
    
    var consumers: [ImageConsumer] { get set }
}

extension ImageSource {
    
    /// Add an image consumer to consume output (texture)
    func add<T>(consumer: T) -> T where T : ImageConsumer {
        consumers.append(consumer)
        consumer.add(source: self)
        return consumer
    }
    
    /// Remove image consumer
    func remove(consumer: ImageConsumer) {
        guard let index = consumers.firstIndex(where: { $0 === consumer }) else {
            return
        }
        consumers.remove(at: index)
        consumer.remove(source: self)
    }
    
    /// Remove all image consumer
    func clear() {
        consumers.removeAll()
        for consumer in consumers {
            consumer.remove(source: self)
        }
    }
}

/// Define behaviors of image consumer  (ex: metalview)
public protocol ImageConsumer: AnyObject {
    
    /// Add provider to get texture
    func add(source: ImageSource)
    
    /// Remove provider (image source)
    func remove(source: ImageSource)
    
    /// Receive new texture from source
    func newTextureAvailable(_ texture: ZATexture, from source: ImageSource)
}
