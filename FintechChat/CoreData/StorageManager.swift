//
//  StorageManager.swift
//  FintechChat
//
//  Created by Ирина Улитина on 22/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import CoreData

class StorageManager {
    public static var shared = StorageManager()
    
    private var stack: CoreDataStack
    
    init() {
        stack = CoreDataStack()
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
    
    public func saveUserProfileState(profileState: UserProfileState, completion: (() ->())?, in context: NSManagedObjectContext? = nil) {
        let context = context ?? self.stack.mainContext
        let user = AppUser.getOrCreateAppUser(in: context)
        context.performAndWait {
            user?.username = profileState.username
            user?.detailInfo = profileState.detailInfo
            user?.profileImage = profileState.profileImage?.pngData()
            user?.timestamp = Date()
        }
        self.stack.performSave(with: context, completion: completion)

    }
    
    public func getUserProfileState(from context: NSManagedObjectContext? = nil) -> UserProfileState {
        let context = context ?? self.stack.mainContext
        let user = AppUser.getOrCreateAppUser(in: context)
        self.stack.performSave(with: context, completion: nil)
        
        
        
        return UserProfileState(username: user?.username, profileImage: UIImage(data: user?.profileImage ?? UserProfileState.defaultImageData), detailInfo: user?.detailInfo)
    }
    
    public func foundedNewUser(userId: String, username: String?) -> User {
        //CHANGE TO SAVE CONTEXT
        let user = User.insertUser(into: self.mainContext)
        
        self.mainContext.performAndWait {
            user?.userId = userId
            user?.isOnline = true
            user?.name = username
            //user?.appUser = AppUser.insertAppUser(into: self.saveContext)
            //user?.appUser?.username = username
        }
        self.stack.performSave(with: self.mainContext)

        return user!
    }
    
    public func updateUserOnlineState(user: User?, isOnline: Bool) {
        self.mainContext.performAndWait {
            user?.isOnline = isOnline
        }
        self.stack.performSave(with: self.mainContext)

    }
    
    public func createConversation(with user: User) -> Conversation {
        let conv = Conversation.insertConversation(into: self.mainContext)
        
        self.mainContext.performAndWait {
            conv?.conversationId = user.userId
            conv?.appUser = AppUser.getOrCreateAppUser(in: self.mainContext)
            conv?.addToParticipants(user)
            conv?.isOnline = true
        }
        self.stack.performSave(with: self.saveContext)

        return conv!
    }
    
    public func createMessage(from: String, to: String, text: String, conversation: Conversation) {
        let message = Message.insert(into: self.mainContext)
        self.mainContext.performAndWait {
            message?.text = text
            message?.receiverId = to
            message?.senderId = from
            message?.conversation = conversation
            message?.didRead = false
            conversation.lastMessage = message
            message?.timestamp = Date()
            message?.messageId = MessageIDGenerator.generateMessageId()
            if let mes = message {
                conversation.addToMessages(mes)
            }

        }
        self.stack.performSave(with: self.mainContext)

    }
    
    
    public func updateConversationOnlineStatus(conversation: Conversation, isOnline: Bool) {
        self.mainContext.performAndWait {
            conversation.isOnline = isOnline

        }
        self.stack.performSave(with: self.mainContext)

    }
    
    public func markAsReadMessages(in conversation: Conversation) {
        self.mainContext.performAndWait {
            for el in conversation.messages ?? NSSet(array: []) {
                (el as! Message).didRead = true
            }

        }
        self.stack.performSave(with: self.mainContext)

        
    }
}
