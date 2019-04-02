//
//  MessagesExtension.swift
//  FintechChat
//
//  Created by Ирина Улитина on 28/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import CoreData

extension Message {
    
    static func insert(into context: NSManagedObjectContext) -> Message? {
        var mes: Message?
        context.performAndWait {
            guard let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as? Message else { return }
            mes = message
        }
        
        return mes
    }
    
    static func fetchMessagesInConversation(conversationID: String) -> NSFetchRequest<Message> {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.predicate = NSPredicate(format: "conversation.conversationId == %@", conversationID)
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        return request
    }
}
