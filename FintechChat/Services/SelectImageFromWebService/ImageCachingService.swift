//
//  CachingService.swift
//  FintechChat
//
//  Created by Ирина Улитина on 16/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

class ImageCacheItem: Equatable {
    
    var image: UIImage?
    var timestamp: Date
    var imageUrl: String
    
    init(image: UIImage?, imageUrl: String) {
        self.imageUrl = imageUrl
        self.image = image
        self.timestamp = Date()//fetch date
    }
    
    static func == (lhs: ImageCacheItem, rhs: ImageCacheItem) -> Bool {
        return lhs.imageUrl == rhs.imageUrl
    }
}

protocol IImageCachingService {
    func cacheImage(image: UIImage?, forUrl: String)
    
    func searchForImage(forUrl: String) -> UIImage?
}

class ImageCachingService: IImageCachingService {
    
    private var maximumCachedImages = 100
    private var batchSize = 20
    private var savingQueue = DispatchQueue(label: "ImageCachingQueue", qos: .background)
    private var urlQueue: Queue<String> = Queue<String>()
    private var imagesDict: [String: UIImage] = [:]
    
    //Иногда ссылки на одни и те же фотку меняются и значимый префикс ~
    private func deleteUnmeaningSymbolsFromUrl(url: String) -> String {
        guard let underscorePrefix = url.index(of: "_") else { return url }
        let offset = underscorePrefix.utf16Offset(in: url)
        let from = offset - 5
        var copyUrl = url
        copyUrl.removeSubrange(String.Index(utf16Offset: from, in: url)..<underscorePrefix)
        return copyUrl
    }
    
    func cacheImage(image: UIImage?, forUrl: String) {
        let meaningUrl = deleteUnmeaningSymbolsFromUrl(url: forUrl)
        savingQueue.async {
            if let image = image {
                if !self.imagesDict.keys.contains(meaningUrl) {
                    self.urlQueue.push(meaningUrl)
                }
                self.imagesDict[meaningUrl] = image
                self.shrinkQueueToFit()
            }
        }
    }
    
    private func shrinkQueueToFit() {
        savingQueue.async {
            Logger.log("CACHE")
            Logger.log(self.urlQueue.count.description)
            Logger.log(self.imagesDict.count.description)
            guard self.urlQueue.count > self.maximumCachedImages + self.batchSize else { return }
            while self.urlQueue.count > self.maximumCachedImages {
                if let front = self.urlQueue.front() {
                    self.imagesDict.removeValue(forKey: front)
                }
                self.urlQueue.popFront()
            }
        }
    }
    
    func searchForImage(forUrl: String) -> UIImage? {
        return savingQueue.sync {
            let meaningUrl = self.deleteUnmeaningSymbolsFromUrl(url: forUrl)
            return self.imagesDict[meaningUrl]
        }
    }
    
    init(maximumCachedImages: Int = 100, batchSize: Int = 20) {
        self.maximumCachedImages = maximumCachedImages
        self.batchSize = batchSize
    }
}
