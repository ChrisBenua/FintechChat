//
//  CellModelHelper.swift
//  FintechChat
//
//  Created by Ирина Улитина on 21/02/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation

class ConversationCellModelHelper: ConversationCellConfiguration {
    var name: String?
    
    var message: String?
    
    var date: Date?
    
    var online: Bool
    
    var hasUnreadMessages: Bool
    
    init(name: String?, message: String?, date: Date?, online: Bool, hasUnreadMessages: Bool) {
        self.name = name
        self.message = message
        self.date = date
        self.online = online
        self.hasUnreadMessages = hasUnreadMessages
    }
}
