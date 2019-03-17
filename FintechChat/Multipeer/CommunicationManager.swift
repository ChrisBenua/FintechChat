//
//  CommunicationManager.swift
//  FintechChat
//
//  Created by Ирина Улитина on 15/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class CommunicationManager: CommunicatorDelegate {
    
    var communicator: MultipeerCommunicator
    
    func didFoundUser(userID: String, username: String?) {
        print("CommunicationManager: found user with \(userID)")
        self.contollerDataProvider?.didFoundUser(userID: userID, username: username)
    }
    
    func didLostUser(userID: String) {
        print("CommunicationManager: lost user with \(userID)")
        self.contollerDataProvider?.didLostUser(userID: userID)
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        print("CommunicationManager: failed to start browsing: \(error)")
    }
    
    func failedToStartAdvertising(error: Error) {
        print("CommunicationManager: failed to start advertising: \(error)")
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        print("CommunicationManager: didReceiveMessage with text:\(text), fromUser: \(fromUser), toUser: \(toUser)")
        self.contollerDataProvider?.didReceiveMessage(text: text, fromUser: fromUser, toUser: toUser)
    }
    
    public static var shared: CommunicationManager!
    
    weak var contollerDataProvider: CommunicatorDelegate?
    
    init(username: String) {
        self.communicator = MultipeerCommunicator(username: username)
        self.communicator.delegate = self
        self.contollerDataProvider = ConversationListDataProvider.shared
    }
    
}
