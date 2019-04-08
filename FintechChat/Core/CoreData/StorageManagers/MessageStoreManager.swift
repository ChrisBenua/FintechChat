//
//  MessageStoreManager.swift
//  FintechChat
//
//  Created by Ирина Улитина on 04/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import CoreData

class MessageStoreManager: IMessageStorageManager {
    
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
    
    var stack: ICoreDataStack
    
    init(stack: ICoreDataStack) {
        self.stack = stack
    }
    
    func createMessage(fromId: String, toId: String, text: String, conversation: Conversation) {
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
                self.stack.performSave(with: self.saveContext, completion: nil)
            }
        }
    }
    
    
    
    func markAsReadMessages(in conversation: Conversation) {
        DispatchQueue.global(qos: .background).async {
            let objectId = conversation.objectID
            self.saveContext.performAndWait {
                let conversationInSaveContext = self.saveContext.object(with: objectId) as? Conversation
                for message in conversationInSaveContext?.messages ?? NSSet(array: []) {
                    if let message = message as? Message {
                        message.didRead = true
                    }
                }
                self.stack.performSave(with: self.saveContext, completion: nil)
                
            }
        }
    }
}
