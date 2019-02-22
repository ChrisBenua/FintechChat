//
//  ConversationMessageModelHelper.swift
//  FintechChat
//
//  Created by Ирина Улитина on 21/02/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation


class ConversationMessageModelHelper: MessageCellExtendedConfiguration {
    var isIncoming: Bool!
    
    var messageText: String?
    
    init(messageText: String?, isIncoming: Bool!) {
        self.messageText = messageText
        self.isIncoming = isIncoming
    }
}
