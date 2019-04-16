//
// Created by Ирина Улитина on 2019-04-11.
// Copyright (c) 2019 Christian Benua. All rights reserved.
//

import Foundation

enum PhotoFetchingType {
    case preview
    case full
}

protocol IImageDownloadingService {
    func downloadImage(type: PhotoFetchingType, forUrl: String, completion: @escaping (UIImage?) -> Void)

    var requestSender: IRequestSender { get set }
}

class ImageDownloadingService: IImageDownloadingService {
    private var imageDownloadingServiceQueue = DispatchQueue(label: "imageDownloadingServiceQueue", qos: .background)
    
    func downloadImage(type: PhotoFetchingType, forUrl: String, completion: @escaping (UIImage?) -> Void) {
        self.imageDownloadingServiceQueue.async {
            let cachingService = type == .preview ? self.previewImageCachingService: self.fullImageCachingService
            if let image = cachingService.searchForImage(forUrl: forUrl) {
                completion(image)
                return
            }
            let config = RequestFactory.ImageFetchRequests.fetchImage(with: forUrl)
            self.requestSender.send(requestConfig: config) { (result) in
                switch result {
                case .success(let image):
                    cachingService.cacheImage(image: image, forUrl: forUrl)
                    completion(image)
                case .error(let str):
                    Logger.log("Error in fetching image")
                    Logger.log(str)
                    completion(nil)
                }
            }
        }
    }

    private var previewImageCachingService: IImageCachingService
    private var fullImageCachingService: IImageCachingService
    
    var requestSender: IRequestSender

    init(requestSender: IRequestSender = DefaultRequestSender()) {
        self.requestSender = requestSender
        self.previewImageCachingService = ImageCachingService()
        self.fullImageCachingService = ImageCachingService(maximumCachedImages: 10, batchSize: 2)
    }

}
