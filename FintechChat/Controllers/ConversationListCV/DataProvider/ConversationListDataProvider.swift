//
//  ConversationListDataProvider.swift
//  FintechChat
//
//  Created by Ирина Улитина on 17/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation

class MessageData {
    var message: String?
    var isIncoming: Bool
    var didRead: Bool
    var date: Date
    
    init(text: String?, isIncoming: Bool, date: Date = Date(), didRead: Bool = false) {
        self.message = text
        self.isIncoming = isIncoming
        self.didRead = didRead
        self.date = date
    }
    
}


protocol UpdateConversationListControllerDelegate: class {
    func updateConversationList()
}

protocol UpdateConversationControllerDelegate: class {
    func updateConversation()
}

class ConversationListDataProvider {
    
    weak var listViewController: UpdateConversationListControllerDelegate?
    weak var conversationViewController: UpdateConversationControllerDelegate?
    
    var onlineUsers: [(String, String)] = [] {
        didSet {
            updateSearchedMessages()
            listViewController?.updateConversationList()
        }
    }
    
    private func updateSearchedMessages() {
        self.searchedMessages = messageStorage.filter { (arg0) -> Bool in
            
            let (key, _) = arg0
            return (key.contains(filterString) || filterString.count == 0) && self.onlineUsers.contains(where: { (el) -> Bool in
                el.0 == key || el.1 == key
            })
        }
    }
    
    var filterString: String = "" {
        didSet {
            updateSearchedMessages()
            listViewController?.updateConversationList()
        }
    }
    
    func getUsernameBy(userId: String) -> String {
        return onlineUsers.first(where: { (el) -> Bool in
            el.0 == userId
        })?.1 ?? userId
    }
    
    func getUserIdBy(username: String) -> String {
        return onlineUsers.first(where: { (el) -> Bool in
            el.1 == username
        })?.0 ?? username
    }
    
    var messageStorage: [String: [MessageData]] = [:]
    
    private var searchedMessages: [String: [MessageData]] = [:]
    
    var searchedMessageStorage: [String: [MessageData]] {
        get {
            return searchedMessages
        }
    }
    
    
    
    public static var shared = ConversationListDataProvider()
    
    private func predicate(el1: (key: String, value: [MessageData]), el2: (key: String, value: [MessageData])) -> Bool {
        if let lastEl1 = el1.value.last?.date {
            if let lastEl2 = el2.value.last?.date {
                let res = lastEl1.compare(lastEl2)
                if res == .orderedSame {
                    return el1.key < el2.key
                }
                return res == .orderedDescending
            }
            return true
        }
        if el2.value.last == nil && el1.value.last == nil {
            return el1.key < el2.key
        }
        return false
    }
    
    func allConversationListCellData() -> [ConversationCellConfiguration] {
        self.updateSearchedMessages()
        let model = searchedMessages.sorted(by: predicate(el1:el2:))
        
        return model.compactMap { (val) -> ConversationCellModelHelper in
            ConversationCellModelHelper(name: self.getUsernameBy(userId: val.key), message: val.value.last?.message, date: val.value.last?.date ?? Date(timeIntervalSince1970: 0), online: true, hasUnreadMessages: !(val.value.last?.didRead ?? true))
        }
    }
    
    func getConversationCellData(name: String) -> [ConversationMessageModelHelper] {
        return searchedMessages.filter({ (el) -> Bool in
            el.key == name
        }).first!.value.compactMap({ (el) -> ConversationMessageModelHelper in
            ConversationMessageModelHelper(messageText: el.message, isIncoming: el.isIncoming)
        })
    }
    
    func markAsReadAllConversation(with name: String) {
        for el in searchedMessages.filter({$0.key == name}).first!.value {
            el.didRead = true
        }
        self.listViewController?.updateConversationList()
    }
}

extension ConversationListDataProvider: CommunicatorDelegate {
    func didFoundUser(userID: String, username: String?) {
        if !onlineUsers.contains(where: { (el) -> Bool in
            el.0 == userID
        }) {
            onlineUsers.insert((userID, username ?? userID), at: 0)
            updateSearchedMessages()
            if (!self.messageStorage.keys.contains(userID)) {
                self.messageStorage[userID] = []
            }
        }
        self.listViewController?.updateConversationList()
    }
    
    func didLostUser(userID: String) {
        onlineUsers.removeAll { (el) -> Bool in
            el.0 == userID
        }
        self.updateSearchedMessages()
        self.listViewController?.updateConversationList()

    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        
    }
    
    func failedToStartAdvertising(error: Error) {
        
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        if (fromUser == CommunicationManager.shared.communicator.userPeerID.displayName) {
            self.messageStorage[toUser]?.append(MessageData(text: text, isIncoming: false))
        } else {
            self.messageStorage[fromUser]?.append(MessageData(text: text, isIncoming: true))
        }
        self.listViewController?.updateConversationList()
        self.conversationViewController?.updateConversation()

    }
    
    
}
