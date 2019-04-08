//
//  RetryAlertControllerService.swift
//  FintechChat
//
//  Created by Ирина Улитина on 05/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

protocol IRetryAlertControllerService {
    func generateRetryAlertController(retryFunc: @escaping (Any?) -> Void?) -> UIAlertController
}

class RetryAlertControllerService: IRetryAlertControllerService {
    func generateRetryAlertController(retryFunc: @escaping (Any?) -> Void?) -> UIAlertController {
        let alertController = UIAlertController(title: "Error", message: "Can't save to file", preferredStyle: .alert)
        let okAction = UIAlertAction.okAction
        
        let retryAction = UIAlertAction(title: "Retry", style: .default) { (_) in
            retryFunc(nil)
        }
        alertController.addAction(okAction)
        alertController.addAction(retryAction)
        
        return alertController
    }
    
    
}
