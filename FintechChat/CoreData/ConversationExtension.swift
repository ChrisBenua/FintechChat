//
//  ConversationExtension.swift
//  FintechChat
//
//  Created by Ирина Улитина on 28/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import CoreData

extension Conversation {
    
    @objc func getSectionName() -> String {
        return self.isOnline ? "Online" : "Offline"
    }
    
    static func insertConversation(into context: NSManagedObjectContext) -> Conversation? {
        var conv: Conversation? = nil
        
        context.performAndWait {
             guard let conversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as? Conversation else { return  }
            conv = conversation
        }
       
        
        return conv
    }
    
    static func fetchConversationWith(conversationId: String) -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        request.predicate = NSPredicate(format: "conversationId == %@", conversationId)
        
        return request
    }
    
    static func fetchOnlineConversation() -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        request.predicate = NSPredicate(format: "isOnline == TRUE")
        
        return request
    }
    
    static func fetchSortedByDateConversations() -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "isOnline", ascending: false), NSSortDescriptor(key: "lastMessage.timestamp", ascending: false)]
        
        return request
    }
    
}
