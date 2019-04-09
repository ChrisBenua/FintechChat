//
//  ConversationModel.swift
//  FintechChat
//
//  Created by Ирина Улитина on 08/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol IConversationViewControllerModel: IMessageStorageManager, IConversationStorageManager, OnUserDisconnectedDelegate {
    var communicator: ICommunicationManager { get }
    
    var dialogTitle: String { get }
    
    var connectedUserID: String { get }
}

class ConversationViewControllerModel: IConversationViewControllerModel {
    var dialogTitle: String
    
    var connectedUserID: String
    
    func userDidDisconnected(stateDict: [String: MCSessionState]) {
        self.disconnectService.userDidDisconnected(stateDict: stateDict)
    }
    
    func createConversation(with user: User, completion: @escaping (Conversation) -> Void) {
        self.storage.createConversation(with: user, completion: completion)
    }
    
    func updateConversationOnlineStatus(conversation: Conversation, isOnline: Bool) {
        self.storage.updateConversationOnlineStatus(conversation: conversation, isOnline: isOnline)
    }
    
    func fetchConversation(withId: String) -> Conversation? {
        return self.storage.fetchConversation(withId: withId)
    }
    
    var communicator: ICommunicationManager
    
    func createMessage(fromId: String, toId: String, text: String, conversation: Conversation) {
        self.storage.createMessage(fromId: fromId, toId: toId, text: text, conversation: conversation)
    }
    
    func markAsReadMessages(in conversation: Conversation) {
        self.storage.markAsReadMessages(in: conversation)
    }
    
    var storage: (IMessageStorageManager & IConversationStorageManager)
    
    var disconnectService: IOnDisconnectedService
    
    init(storage: (IMessageStorageManager & IConversationStorageManager), communicator: ICommunicationManager, disconnectService: IOnDisconnectedService, dialogTitle: String, connectedUserID: String) {
        self.storage = storage
        self.communicator = communicator
        self.disconnectService = disconnectService
        self.dialogTitle = dialogTitle
        self.connectedUserID = connectedUserID
    }
}
