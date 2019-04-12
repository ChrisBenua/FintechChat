//
//  OnDisconnectedService.swift
//  FintechChat
//
//  Created by Ирина Улитина on 09/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol IOnDisconnectedService: OnUserDisconnectedDelegate {
    var viewController: (UIViewController & ISubmittableViewController & IDialogViewController)! { get set }
}

class OnDisconnectedService: IOnDisconnectedService {
    func userDidDisconnected(stateDict: [String: MCSessionState]) {
        let state = stateDict[self.viewController.connectedUserID]
        if let state = state {
            DispatchQueue.main.async {
                
                if state == .connected {
                    self.viewController.toggleEditingButton(true)
                    //self.viewController.submitButton.isEnabled = true
                } else if !self.viewController.didLeaveDialog {
                    
                    if state == .notConnected {
                        self.viewController.toggleEditingButton(false)
                        //self.viewController.submitButton.isEnabled = false
                        let alertController = UIAlertController(title: "Alert", message: "This peer disconnected from you", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction.okAction)
                        alertController.addAction(UIAlertAction(title: "Leave dialog", style: .destructive, handler: { [weak self] (_) in
                            self?.viewController.navigationController?.popViewController(animated: true)
                        }))
                        self.viewController.present(alertController, animated: true, completion: nil)
                    } else if state == .connected {
                        self.viewController.toggleEditingButton(true)
                    }
                }
            }
            
        }
    }
    
    var viewController: (UIViewController & ISubmittableViewController & IDialogViewController)!
    
    init(viewController: (UIViewController & ISubmittableViewController & IDialogViewController)) {
        self.viewController = viewController
    }
    
    init() {
        
    }
    
}
