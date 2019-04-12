//
//  PixabayImage.swift
//  FintechChat
//
//  Created by Ирина Улитина on 11/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation

protocol IPixabyImageInfo: Decodable {
    var previewUrl: String { get set }
    var fullImageUrl: String { get set }
}

class PixabayItemsCollection: Decodable {
    var hits: [PixabayImageInfo]
}

class PixabayImageInfo: IPixabyImageInfo {

    var previewUrl: String
    var fullImageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case previewUrl = "previewURL"
        case fullImageUrl = "largeImageURL"
    }
}

extension PixabayImageInfo: Equatable {
    static func == (lhs: PixabayImageInfo, rhs: PixabayImageInfo) -> Bool {
        return lhs.previewUrl == rhs.previewUrl && lhs.fullImageUrl == rhs.fullImageUrl
    }
}
