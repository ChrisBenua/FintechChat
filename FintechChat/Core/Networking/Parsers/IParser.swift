//
//  IParser.swift
//  FintechChat
//
//  Created by Ирина Улитина on 11/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation

protocol IParser {
    associatedtype Model
    
    func parse(data: Data) -> Model?
}


class DefaultParser<T: Decodable>: IParser {
    
    func parse(data: Data) -> T? {
        do {
            let parsedObject = try JSONDecoder().decode(T.self, from: data)
            return parsedObject
        } catch let err {
            Logger.log("Cant parse objects")
            Logger.log(err.localizedDescription)
            return nil
        }
    }
    
    typealias Model = T
}

class ImageParser: IParser {
    
    func parse(data: Data) -> UIImage? {
        return UIImage(data: data)
    }
    
    typealias Model = UIImage
}
