//
//  StorageManager.swift
//  FintechChat
//
//  Created by Ирина Улитина on 22/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import CoreData

protocol ISharedBaseStorageManager: IBaseStorageManager {
    static var shared: IBaseStorageManager { get }

}

protocol IBaseStorageManager {
    
    var stack: ICoreDataStack { get }
    
    var saveContext: NSManagedObjectContext { get }
    
    var mainContext: NSManagedObjectContext { get }
}

protocol IUserProfileStorageManager: IBaseStorageManager {
    
    func saveUserProfileState(profileState: UserProfileState, completion: (() -> Void)?, in context: NSManagedObjectContext?)
    
    func getUserProfileState(from context: NSManagedObjectContext?, completion: ((UserProfileState) -> Void)?)
    
}

protocol IUsersStorageManager: IBaseStorageManager {
    func updateUsersUsername(user: User, newUsername: String?, completion: (() -> Void)?)
    
    func foundedNewUser(userId: String, username: String?, completion: @escaping (User) -> Void)
    
    func updateUserOnlineState(user: User?, isOnline: Bool)
}

protocol IConversationStorageManager: IBaseStorageManager {
    func createConversation(with user: User, completion: @escaping (Conversation) -> Void)
    
    func updateConversationOnlineStatus(conversation: Conversation, isOnline: Bool)
    
    func fetchConversation(withId: String) -> Conversation?
}

protocol IMessageStorageManager: IBaseStorageManager {
    func createMessage(fromId: String, toId: String, text: String, conversation: Conversation)
    func markAsReadMessages(in conversation: Conversation)
}

protocol IStorageCoordinator: IUserProfileStorageManager, IUsersStorageManager, IMessageStorageManager, IConversationStorageManager {
    static var shared: IStorageCoordinator { get }
    
    func performSave(in context: NSManagedObjectContext)
}


class StorageManager: IStorageCoordinator {
    
    static var shared: IStorageCoordinator = StorageManager()
    
    private var privateStack: ICoreDataStack
    
    public var stack: ICoreDataStack {
        get {
            return privateStack
        }
    }
    
    private var messageManager: IMessageStorageManager
    
    private var conversationManager: IConversationStorageManager
    
    private var userManager: IUsersStorageManager
    
    private var userProfileManager: IUserProfileStorageManager
    
    //потом тут будет инит из ассамблеи
    init() {
        self.privateStack = CoreDataStack()
        self.messageManager = MessageStoreManager(stack: privateStack)
        self.conversationManager = ConversationStorageManager(stack: privateStack)
        self.userManager = UserStorageManager(stack: privateStack)
        self.userProfileManager = UserProfileStorageManager(stack: privateStack)
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
    
    func performSave(in context: NSManagedObjectContext) {
        DispatchQueue.global(qos: .background).async {
            self.stack.performSave(with: context, completion: nil)
        }
    }
    
    public func saveUserProfileState(profileState: UserProfileState, completion: (() -> Void)?, in context: NSManagedObjectContext? = nil) {
       self.userProfileManager.saveUserProfileState(profileState: profileState, completion: completion, in: context)
    }
    
    public func updateUsersUsername(user: User, newUsername: String?, completion: (() -> Void)?) {
        self.userManager.updateUsersUsername(user: user, newUsername: newUsername, completion: completion)
    }
    
    public func getUserProfileState(from context: NSManagedObjectContext? = nil, completion: ((UserProfileState) -> Void)?) {
        self.userProfileManager.getUserProfileState(from: context, completion: completion)
    }
    
    public func foundedNewUser(userId: String, username: String?, completion: @escaping (User) -> Void) {
        
        self.userManager.foundedNewUser(userId: userId, username: username, completion: completion)
    }
    
    public func updateUserOnlineState(user: User?, isOnline: Bool) {
        
        self.userManager.updateUserOnlineState(user: user, isOnline: isOnline)
    }
    
    public func createConversation(with user: User, completion: @escaping (Conversation) -> Void) {
        
        self.conversationManager.createConversation(with: user, completion: completion)
    }
    
    public func createMessage(fromId: String, toId: String, text: String, conversation: Conversation) {
        
        self.messageManager.createMessage(fromId: fromId, toId: toId, text: text, conversation: conversation)
    }
    
    
    public func updateConversationOnlineStatus(conversation: Conversation, isOnline: Bool) {
        self.conversationManager.updateConversationOnlineStatus(conversation: conversation, isOnline: isOnline)
    }
    
    func fetchConversation(withId: String) -> Conversation? {
        return self.conversationManager.fetchConversation(withId: withId)
    }
    
    public func markAsReadMessages(in conversation: Conversation) {
        
        self.messageManager.markAsReadMessages(in: conversation)
    }
    
}
