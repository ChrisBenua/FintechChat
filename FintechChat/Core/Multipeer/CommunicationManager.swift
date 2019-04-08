//
//  CommunicationManager.swift
//  FintechChat
//
//  Created by Ирина Улитина on 15/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol ICommunicationManager: CommunicatorDelegate {
    var contollerDataProvider: CommunicatorDelegate? { get set }
    var communicator: MultipeerCommunicator { get set }
}

class CommunicationManager: ICommunicationManager {

    var communicator: MultipeerCommunicator

    func didFoundUser(userID: String, username: String?) {
        Logger.log("CommunicationManager: found user with \(userID)")
        self.contollerDataProvider?.didFoundUser(userID: userID, username: username)
    }

    func didLostUser(userID: String) {
        Logger.log("CommunicationManager: lost user with \(userID)")
        self.contollerDataProvider?.didLostUser(userID: userID)
    }

    func failedToStartBrowsingForUsers(error: Error) {
        Logger.log("CommunicationManager: failed to start browsing: \(error)")
        self.contollerDataProvider?.failedToStartBrowsingForUsers(error: error)

    }

    func failedToStartAdvertising(error: Error) {
        Logger.log("CommunicationManager: failed to start advertising: \(error)")
        self.contollerDataProvider?.failedToStartBrowsingForUsers(error: error)
    }

    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        Logger.log("CommunicationManager: didReceiveMessage with text:\(text), fromUser: \(fromUser),toUser: \(toUser)")
        self.contollerDataProvider?.didReceiveMessage(text: text, fromUser: fromUser, toUser: toUser)
    }

    public static var shared: CommunicationManager!

    weak var contollerDataProvider: CommunicatorDelegate?

    init(username: String) {
        self.communicator = MultipeerCommunicator(username: username)
        self.communicator.delegate = self
        //self.contollerDataProvider = ConversationListDataProvider.shared
    }

}


extension MCSessionState {
    func myDebug() -> String {
        if self == .connected {
            return "MCSessionState.connected"
        } else if self == .notConnected {
            return "MCSessionState.notConnected"
        } else {
            return "MCSessionState.connecting"
        }
    }
}
