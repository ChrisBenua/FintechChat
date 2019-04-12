//
// Created by Ирина Улитина on 2019-04-11.
// Copyright (c) 2019 Christian Benua. All rights reserved.
//

import Foundation

protocol IImageDownloadingService {
    func downloadImage(forUrl: String, completion: @escaping (UIImage?) -> Void)

    var requestSender: IRequestSender { get set }
}

class ImageDownloadingService: IImageDownloadingService {
    func downloadImage(forUrl: String, completion: @escaping (UIImage?) -> Void) {
        let config = RequestFactory.ImageFetchRequests.fetchImage(with: forUrl)
        self.requestSender.send(requestConfig: config) { (result) in
            switch result {
            case .success(let image):
                completion(image)
            case .error(let str):
                Logger.log("Error in fetching image")
                Logger.log(str)
                completion(nil)
            }
        }
    }

    var requestSender: IRequestSender

    init(requestSender: IRequestSender = DefaultRequestSender()) {
        self.requestSender = requestSender
    }

}
