//
//  ImageLoadingRequest.swift
//  FintechChat
//
//  Created by Ирина Улитина on 11/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation

class ImageLoadingRequest: IRequest {
    
    private var rawUrl: String
    
    var urlRequest: URLRequest? {
        get {
            if let url = URL(string: rawUrl) {
                return URLRequest(url: url)
            }
            return nil
        }
    }
    
    init(rawUrl: String) {
        self.rawUrl = rawUrl
    }
    
}
