//
//  Message.swift
//  FintechChat
//
//  Created by Ирина Улитина on 15/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation

class Message: Codable {
    var eventType: String
    var text: String
    var messageId: String
    
    init(text: String) {
        self.text = text
        self.eventType = "TextMessage"
        self.messageId = MessageIDGenerator.generateMessageId()
    }
    
    init(text: String, messageId: String, eventType: String = "TextMessage") {
        self.text = text
        self.messageId = messageId
        self.eventType = eventType
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.eventType = (aDecoder.decodeObject(forKey: "eventType") as? String) ?? ""
        self.text = (aDecoder.decodeObject(forKey: "text") as? String) ?? ""
        self.messageId = (aDecoder.decodeObject(forKey: "messageId") as? String) ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(eventType, forKey: "eventType")
        aCoder.encode(text, forKey: "text")
        aCoder.encode(messageId, forKey: "messageId")
    }
}
