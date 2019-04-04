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
        var conv: Conversation?
        
        context.performAndWait {
             guard let conversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as? Conversation else { return  }
            conv = conversation
        }
       
        
        return conv
    }
    
    static func requestConversationWith(conversationId: String) -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        request.predicate = NSPredicate(format: "conversationId == %@", conversationId)
        
        return request
    }
    
    static func requestOnlineConversation() -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        request.predicate = NSPredicate(format: "isOnline == TRUE")
        
        return request
    }
    
    static func requestSortedByDateConversations() -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "isOnline", ascending: false), NSSortDescriptor(key: "lastMessage.timestamp", ascending: false)]
        
        return request
    }
    
    func toConversationModel() -> ConversationCellModelHelper {
        return ConversationCellModelHelper(name: self.participants?.name, message: self.lastMessage?.text, date: self.lastMessage?.timestamp, online: self.isOnline, hasUnreadMessages: !(self.lastMessage?.didRead ?? false))
    }
    
}
