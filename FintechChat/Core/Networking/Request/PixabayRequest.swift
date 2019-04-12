//
//  PixabayRequest.swift
//  FintechChat
//
//  Created by Ирина Улитина on 11/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation

class PixabayRequest: IRequest {
    
    private var baseURL = "https://pixabay.com/api/?"
    
    private var apiKey = "12167201-0739b897ec985fc929d4635fb"
    
    var urlRequest: URLRequest? {
        get {
            Logger.log("CompletedURL: \(baseURL + self.paramsToQueryString())")
            if let url = URL(string: baseURL + self.paramsToQueryString()) {
                return URLRequest(url: url)
            }
            return nil
        }
    }
    var parameters: [String: CustomStringConvertible] = ["q": "flower", "image_type": "photo"]
    
    private func paramsToQueryString() -> String {
        var queryString = "key=\(apiKey)"
        if !parameters.isEmpty {
            //queryString += "&"
            for param in parameters.keys {
                queryString += "&\(param)=\(String(describing: parameters[param]!))"
            }
        }
        
        return queryString
    }
    
    init(page: Int) {
        parameters["page"] = page
    }
    
    init(params: [String: CustomStringConvertible]) {
        self.parameters = params
    }
    
}
