//
//  ConversationModel.swift
//  FintechChat
//
//  Created by Ирина Улитина on 08/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation

protocol IConversationViewControllerModel: IMessageStorageManager, IConversationStorageManager {
    var communicator: ICommunicationManager { get }
}

class ConversationViewControllerModel: IConversationViewControllerModel {
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
    
    init(storage: (IMessageStorageManager & IConversationStorageManager), communicator: ICommunicationManager) {
        self.storage = storage
        self.communicator = communicator
    }
}
