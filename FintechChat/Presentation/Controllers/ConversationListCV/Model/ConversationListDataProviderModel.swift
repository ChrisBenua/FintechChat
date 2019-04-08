//
//  ConversationListDataProviderModel.swift
//  FintechChat
//
//  Created by Ирина Улитина on 08/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import CoreData

protocol IConversationListDataProviderModel: IConversationStorageManager, IUsersStorageManager, IMessageStorageManager {
    func getCurrentUserId() -> String
}

class ConversationListDataProviderModel: IConversationListDataProviderModel {
    func getCurrentUserId() -> String {
        return self.communicator.communicator.userPeerID.displayName
    }
    
    func createConversation(with user: User, completion: @escaping (Conversation) -> Void) {
        self.storageManager.createConversation(with: user, completion: completion)
    }
    
    func updateConversationOnlineStatus(conversation: Conversation, isOnline: Bool) {
        self.storageManager.updateConversationOnlineStatus(conversation: conversation, isOnline: isOnline)
    }
    
    func fetchConversation(withId: String) -> Conversation? {
        return self.storageManager.fetchConversation(withId: withId)
    }
    
    func updateUsersUsername(user: User, newUsername: String?, completion: (() -> Void)?) {
        self.storageManager.updateUsersUsername(user: user, newUsername: newUsername, completion: completion)
    }
    
    func foundedNewUser(userId: String, username: String?, completion: @escaping (User) -> Void) {
        self.storageManager.foundedNewUser(userId: userId, username: username, completion: completion)
    }
    
    func updateUserOnlineState(user: User?, isOnline: Bool) {
        self.storageManager.updateUserOnlineState(user: user, isOnline: isOnline)
    }
    
    func createMessage(fromId: String, toId: String, text: String, conversation: Conversation) {
        self.storageManager.createMessage(fromId: fromId, toId: toId, text: text, conversation: conversation)
    }
    
    func markAsReadMessages(in conversation: Conversation) {
        self.storageManager.markAsReadMessages(in: conversation)
    }
    
    var stack: ICoreDataStack {
        get {
            return self.storageManager.stack
        }
    }
    
    var saveContext: NSManagedObjectContext {
        get {
            return self.stack.saveContext
        }
    }
    
    var mainContext: NSManagedObjectContext {
        get {
            return self.stack.mainContext
        }
    }
    
    private var storageManager: IStorageCoordinator
    
    private var communicator: ICommunicationManager
    
    init(storageManager: IStorageCoordinator, communicator: ICommunicationManager) {
        self.storageManager = storageManager
        self.communicator = communicator
    }
    
}
