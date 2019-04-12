//
// Created by Ирина Улитина on 2019-04-11.
// Copyright (c) 2019 Christian Benua. All rights reserved.
//

import Foundation


struct RequestFactory {
    struct PixabayRequests {
        static func fetchPixabayImagesInfo(page: Int = 1) -> RequestConfig<DefaultParser<PixabayItemsCollection>> {
            return RequestConfig<DefaultParser<PixabayItemsCollection>>(request: PixabayRequest(page: page), parser: DefaultParser<PixabayItemsCollection>())
        }
    }

    struct ImageFetchRequests {
        static func fetchImage(with rawUrl: String) -> RequestConfig<ImageParser> {
            return RequestConfig<ImageParser>(request: ImageLoadingRequest(rawUrl: rawUrl), parser: ImageParser())
        }
    }
}
