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
    
    func performSave(in context: NSManagedObjectContext) {
        DispatchQueue.global(qos: .background).async {
            self.stack.performSave(with: context)

        }
    }
    
    public func saveUserProfileState(profileState: UserProfileState, completion: (() -> Void)?, in context: NSManagedObjectContext? = nil) {
        let context = context ?? self.stack.saveContext
        DispatchQueue.global(qos: .background).async {
            AppUser.getOrCreateAppUser(in: context) { user in
                
                context.performAndWait {
                    user?.username = profileState.username
                    user?.detailInfo = profileState.detailInfo
                    user?.profileImage = profileState.profileImage?.pngData()
                    user?.timestamp = Date()
                    self.stack.performSave(with: context, completion: completion)
                }
                
            }
        }
    }
    
    public func updateUsersUsername(user: User, newUsername: String?, completion: (() -> Void)?) {
        DispatchQueue.global(qos: .background).async {
            
            let userObjectId = user.objectID
            
            if let username = newUsername {
                self.saveContext.performAndWait {
                    let saveContextUser = self.saveContext.object(with: userObjectId) as? User
                    saveContextUser?.name = username
                    completion?()
                }
            }
        }
    }
    
    public func getUserProfileStateSync(from context: NSManagedObjectContext? = nil) -> UserProfileState {
        let context = context ?? self.stack.mainContext
        let user = AppUser.getOrCreateAppUserSync(in: context)
        self.stack.performSave(with: context)
        return UserProfileState(username: user?.username, profileImage: UIImage(data: user?.profileImage ?? UserProfileState.defaultImageData), detailInfo: user?.detailInfo)
    }
    
    public func getUserProfileState(from context: NSManagedObjectContext? = nil, completion: ((UserProfileState) -> Void)?) {
        //return DispatchQueue.global(qos: .background).sync {
        let context = context ?? self.stack.saveContext
        DispatchQueue.global(qos: .background).async {
            AppUser.getOrCreateAppUser(in: context) { user in
                user?.managedObjectContext!.performAndWait {
                    user?.username = user?.username ?? "Кристиан Бенуа"
                }
                self.stack.performSave(with: context) {
                    user?.managedObjectContext?.performAndWait {
                        completion?(UserProfileState(username: user?.username, profileImage: UIImage(data: user?.profileImage ?? UserProfileState.defaultImageData), detailInfo: user?.detailInfo))
                    }
                
                }
            }
        }
        
        
       // }
       
    }
    
    public func foundedNewUser(userId: String, username: String?, completion: @escaping (User) -> Void) {
        
        DispatchQueue.global(qos: .background).async {
            let user = User.insertUser(into: self.saveContext)
            self.saveContext.performAndWait {
                user?.userId = userId
                user?.isOnline = true
                user?.name = username
                self.stack.performSave(with: self.saveContext) {
                    DispatchQueue.main.async {
                        completion(user!)
                    }
                }
            }
        }
    }
    
    public func foundedNewUserSync(userId: String, username: String?) -> User {
        //CHANGE TO SAVE CONTEXT
        
        //DispatchQueue.global(qos: .background).async {
        let user = User.insertUser(into: self.mainContext)
        self.mainContext.performAndWait {
            user?.userId = userId
            user?.isOnline = true
            user?.name = username
            self.stack.performSave(with: self.mainContext)
        }
        return user!
       // }
    }
    
    public func updateUserOnlineState(user: User?, isOnline: Bool) {
        
        DispatchQueue.global(qos: .background).async {
            guard let userObjectId = user?.objectID else { return }
            
            self.saveContext.performAndWait {
                let saveContextUser = self.saveContext.object(with: userObjectId) as? User
                saveContextUser?.isOnline = isOnline
                DispatchQueue.main.async {
                    self.stack.performSave(with: self.saveContext)
                }
            }
            
        }
    }
    
    public func createConversation(with user: User, completion: @escaping (Conversation) -> Void) {
        
        DispatchQueue.global(qos: .background).async {
            let conv = Conversation.insertConversation(into: self.saveContext)
            
            self.saveContext.performAndWait {
                conv?.conversationId = user.userId
                AppUser.getOrCreateAppUser(in: self.saveContext) { appUser in
                    self.saveContext.perform {
                        conv?.appUser = appUser
                        conv?.addToParticipants(user)
                        conv?.isOnline = true
                        self.stack.performSave(with: self.saveContext) {
                            DispatchQueue.main.async {
                                completion(conv!)
                            }
                        }
                    }
                }

            }
        }
    }
    
    public func createConversationSync(with user: User) -> Conversation {
        
        //DispatchQueue.global(qos: .background).async {
            let conv = Conversation.insertConversation(into: self.mainContext)
            
            self.mainContext.performAndWait {
                conv?.conversationId = user.userId
                let appUser = AppUser.getOrCreateAppUserSync(in: self.mainContext)
                self.mainContext.performAndWait {
                    conv?.appUser = appUser
                    conv?.addToParticipants(user)
                    conv?.isOnline = true
                }
                
                self.stack.performSave(with: self.mainContext)

            }
        return conv!
        //}
    }
    
    public func createMessage(fromId: String, toId: String, text: String, conversation: Conversation) {
        
        DispatchQueue.global(qos: .background).async {
            let convObjectId = conversation.objectID
            
            let message = Message.insert(into: self.saveContext)
            
            
            self.saveContext.performAndWait {
                let saveContextConversation = self.saveContext.object(with: convObjectId) as? Conversation
                
                message?.text = text
                message?.receiverId = toId
                message?.senderId = fromId
                message?.conversation = conversation
                message?.didRead = false
                saveContextConversation?.lastMessage = message
                message?.timestamp = Date()
                message?.messageId = MessageIDGenerator.generateMessageId()
                if let mes = message {
                    saveContextConversation?.addToMessages(mes)
                }
                self.stack.performSave(with: self.saveContext)
            }
        }
    }
    
    
    public func updateConversationOnlineStatus(conversation: Conversation, isOnline: Bool) {
        let convObjectId = conversation.objectID
        DispatchQueue.global(qos: .background).async {
            self.saveContext.performAndWait {
                let saveContextConversation = self.saveContext.object(with: convObjectId) as? Conversation
                
                saveContextConversation?.isOnline = isOnline
                self.stack.performSave(with: self.saveContext)
            }
            
        }
        
    }
    
    public func markAsReadMessages(in conversation: Conversation) {
        
        DispatchQueue.global(qos: .background).async {
            let objectId = conversation.objectID
            self.saveContext.performAndWait {
                let conversationInSaveContext = self.saveContext.object(with: objectId) as? Conversation
                for message in conversationInSaveContext?.messages ?? NSSet(array: []) {
                    if let message = message as? Message {
                        message.didRead = true
                    }
                }
                self.stack.performSave(with: self.saveContext)

            }
        }
    }
    
}
