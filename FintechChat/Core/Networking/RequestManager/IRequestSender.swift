//
//  IRequestSender.swift
//  FintechChat
//
//  Created by Ирина Улитина on 11/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation

struct RequestConfig<Parser: IParser> {
    let request: IRequest
    let parser: Parser
}

protocol IRequestSender {
    func send<Parser>(requestConfig: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void)
}

enum Result<Model> {
    case success(Model)
    case error(String)
}
