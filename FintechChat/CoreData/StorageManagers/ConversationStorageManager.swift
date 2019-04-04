//
//  ConversationStorageManager.swift
//  FintechChat
//
//  Created by Ирина Улитина on 04/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import CoreData

class ConversationStorageManager: IConversationStorageManager {
    
    func fetchConversation(withId: String) -> Conversation? {
        let fetchRequst = Conversation.requestConversationWith(conversationId: withId)
        var res: [Conversation]?
        do {
            res = try self.mainContext.fetch(fetchRequst)
        } catch let err {
            Logger.log("cant fetch conversation with id \(withId)")
            Logger.log(err.localizedDescription)
        }
        return res?.first
    }
    
    func createConversation(with user: User, completion: @escaping (Conversation) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let conv = Conversation.insertConversation(into: self.saveContext)
            
            self.saveContext.performAndWait {
                conv?.conversationId = user.userId
                AppUser.getOrCreateAppUser(in: self.saveContext) { appUser in
                    self.saveContext.perform {
                        conv?.appUser = appUser
                        conv?.participants = user
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
    
    func updateConversationOnlineStatus(conversation: Conversation, isOnline: Bool) {
        let convObjectId = conversation.objectID
        DispatchQueue.global(qos: .background).async {
            self.saveContext.performAndWait {
                let saveContextConversation = self.saveContext.object(with: convObjectId) as? Conversation
                
                saveContextConversation?.isOnline = isOnline
                self.stack.performSave(with: self.saveContext, completion: nil)
            }
            
        }
    }
    
    var stack: ICoreDataStack
    
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
    
    init(stack: ICoreDataStack) {
        self.stack = stack
    }
    
    
}
