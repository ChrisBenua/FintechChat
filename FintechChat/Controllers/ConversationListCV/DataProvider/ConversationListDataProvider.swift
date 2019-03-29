//
//  ConversationListDataProvider.swift
//  FintechChat
//
//  Created by Ирина Улитина on 17/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import CoreData


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



protocol UpdateConversationControllerDelegate: class {
    func updateConversation()
    func onError(error: Error)
}

class ConversationListDataProvider {
    
    weak var listViewController: UpdateConversationControllerDelegate?
    weak var conversationViewController: UpdateConversationControllerDelegate?
    
    func generateConversationListFRC() -> NSFetchedResultsController<Conversation> {
        let frc = NSFetchedResultsController(fetchRequest: Conversation.fetchSortedByDateConversations(), managedObjectContext: StorageManager.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }
    
    func generateConversationFRC(conversationId: String) -> NSFetchedResultsController<Message> {
        let frc = NSFetchedResultsController(fetchRequest: Message.fetchMessagesInConversation(conversationID: conversationId), managedObjectContext: StorageManager.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return frc
    }
    
    /*var onlineUsers: [(String, String)] = [] {
        didSet {
            updateSearchedMessages()
            listViewController?.updateConversation()
        }
    }*/
    
    var userIdToUser: [String: User] = [:]
    
   /* private func updateSearchedMessages() {
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
            listViewController?.updateConversation()
        }
    }*/
    
    /*func getUsernameBy(userId: String) -> String {
        return userIdToUsername[userId]!
    }*/
    
    /*func getUserIdBy(username: String) -> String {
        return onlineUsers.first(where: { (el) -> Bool in
            el.1 == username
        })?.0 ?? username
    }*/
    
    var userIdToConversation: [String: Conversation] = [:]
    
    //var userIdToUsername: [String: String] = [:]
    
    //var messageStorage: [String: [MessageData]] = [:]
    
    //private var searchedMessages: [String: [MessageData]] = [:]
    
    /*var searchedMessageStorage: [String: [MessageData]] {
        get {
            return searchedMessages
        }
    }*/
    
    
    
    //public static var shared = ConversationListDataProvider()
    
    /*private func predicate(el1: (key: String, value: [MessageData]), el2: (key: String, value: [MessageData])) -> Bool {
        if let lastEl1 = el1.value.last?.date {
            if let lastEl2 = el2.value.last?.date {
                let res = lastEl1.compare(lastEl2)
                if res == .orderedSame {
                    return userIdToUsername[el1.key]! < userIdToUsername[el2.key]!
                }
                return res == .orderedDescending
            }
            return true
        }
        if el2.value.last == nil && el1.value.last == nil {
            return userIdToUsername[el1.key]! < userIdToUsername[el2.key]!
        }
        return false
    }*/
    
    /*func allConversationListCellData() -> [ConversationCellConfiguration] {
        self.updateSearchedMessages()
        let model = searchedMessages.sorted(by: predicate(el1:el2:))
        
        return model.compactMap { (val) -> ConversationCellModelHelper in
            ConversationCellModelHelper(name: self.getUsernameBy(userId: val.key), message: val.value.last?.message, date: val.value.last?.date ?? Date(timeIntervalSince1970: 0), online: true, hasUnreadMessages: !(val.value.last?.didRead ?? true))
        }
    }*/
    
    /*func getConversationCellData(name: String) -> [ConversationMessageModelHelper] {
        if let value =  searchedMessages.filter({ (el) -> Bool in
            el.key == name
        }).first?.value {
            return value.compactMap({ (data) -> ConversationMessageModelHelper in
                 ConversationMessageModelHelper(messageText: data.message, isIncoming: data.isIncoming)
            })
        }
        return []
    }*/
    
    /*func markAsReadAllConversation(with name: String) {
        for el in searchedMessages.filter({$0.key == name}).first!.value {
            el.didRead = true
        }
        self.listViewController?.updateConversation()
    }*/
}

extension ConversationListDataProvider: CommunicatorDelegate {
    func didFoundUser(userID: String, username: String?) {
        // creates or updates user's online status
        if userIdToUser[userID] == nil {
            
            let request = User.fetchUserWithId(id: userID)
            var result = [User]()
            do {
            
                result = try StorageManager.shared.mainContext.fetch(request)
            } catch let err {
                print("Cant fetch USERs with ID")
                print(err)
            }
            
            if (result.count == 0) {
                let newUser = StorageManager.shared.foundedNewUser(userId: userID, username: username)
                userIdToUser[userID] = newUser
            }
            else {
                StorageManager.shared.updateUserOnlineState(user: result[0], isOnline: true)
                userIdToUser[userID] = result[0]
            }
            
        } else {
            StorageManager.shared.updateUserOnlineState(user: userIdToUser[userID], isOnline: true)
        }
        // creates or updates conversation
        if (userIdToConversation[userID] == nil) {
            
            var result = [Conversation]()
            
            do {
                result = try  StorageManager.shared.mainContext.fetch(Conversation.fetchConversationWith(conversationId: userID))
            } catch let err {
                print(err)
            }
            
            if (result.count == 0) {
                userIdToConversation[userID] = StorageManager.shared.createConversation(with: userIdToUser[userID]!)
            } else {
                StorageManager.shared.updateConversationOnlineStatus(conversation: result[0], isOnline: true)
                userIdToConversation[userID] = result[0]
            }
            
        } else {
            StorageManager.shared.updateConversationOnlineStatus(conversation: userIdToConversation[userID]!, isOnline: true)
        }
        
        
        /*userIdToUsername[userID] = username ?? userID
        if !onlineUsers.contains(where: { (el) -> Bool in
            el.0 == userID
        }) {
            onlineUsers.insert((userID, username ?? userID), at: 0)
            updateSearchedMessages()
            if (!self.messageStorage.keys.contains(userID)) {
                self.messageStorage[userID] = []
            }
        }*/
        //self.listViewController?.updateConversation()
    }
    
    func didLostUser(userID: String) {
        StorageManager.shared.updateUserOnlineState(user: userIdToUser[userID], isOnline: false)
        StorageManager.shared.updateConversationOnlineStatus(conversation: userIdToConversation[userID]!, isOnline: false)
        
        /*onlineUsers.removeAll { (el) -> Bool in
            el.0 == userID
        }*/
        //self.updateSearchedMessages()
        //self.listViewController?.updateConversation()

    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        self.listViewController?.onError(error: error)
    }
    
    func failedToStartAdvertising(error: Error) {
        self.listViewController?.onError(error: error)
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        /*if (fromUser == CommunicationManager.shared.communicator.userPeerID.displayName) {
            self.messageStorage[toUser]?.append(MessageData(text: text, isIncoming: false))
        } else {
            self.messageStorage[fromUser]?.append(MessageData(text: text, isIncoming: true))
        }*/
        
        if (fromUser == CommunicationManager.shared.communicator.userPeerID.displayName) {
            StorageManager.shared.createMessage(from: fromUser, to: toUser, text: text, conversation: userIdToConversation[toUser]!)
        } else {
            StorageManager.shared.createMessage(from: fromUser, to: toUser, text: text, conversation: userIdToConversation[fromUser]!)
        }
        
        //self.listViewController?.updateConversation()
        //self.conversationViewController?.updateConversation()

    }
    
    
}
