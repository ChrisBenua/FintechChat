//
//  ConversationListDataProvider.swift
//  FintechChat
//
//  Created by Ирина Улитина on 17/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import CoreData


protocol UpdateConversationControllerDelegate: class {
    func updateConversation()
    func onError(error: Error)
}

protocol IConversationDataProvider: CommunicatorDelegate {
    
    func generateConversationListFRC() -> NSFetchedResultsController<Conversation>
    
    func generateConversationFRC(conversationId: String) -> NSFetchedResultsController<Message>
    
    var listViewController: UpdateConversationControllerDelegate? { get set }
    
    var conversationViewController: UpdateConversationControllerDelegate? { get set }
}

class ConversationListDataProvider: IConversationDataProvider {
    
    weak var listViewController: UpdateConversationControllerDelegate?
    weak var conversationViewController: UpdateConversationControllerDelegate?
    
    func generateConversationListFRC() -> NSFetchedResultsController<Conversation> {
        let frc = NSFetchedResultsController(fetchRequest: Conversation.requestSortedByDateConversations(), managedObjectContext: StorageManager.shared.mainContext, sectionNameKeyPath: "getSectionName", cacheName: nil)
        
        return frc
    }
    
    func generateConversationFRC(conversationId: String) -> NSFetchedResultsController<Message> {
        let frc = NSFetchedResultsController(fetchRequest: Message.requestMessagesInConversation(conversationID: conversationId), managedObjectContext: StorageManager.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return frc
    }
    
    var userIdToUser: [String: User] = [:]
    
    var userIdToConversation: [String: Conversation] = [:]
    
    init() {
        let userRequest: NSFetchRequest<User> = User.fetchRequest()
        //do {
            var results: [User] = []
            var appUsers: ([AppUser]?)
            //DispatchQueue.global(qos: .background).async  {
                StorageManager.shared.saveContext.perform {
                    do {
                        results = try StorageManager.shared.saveContext.fetch(userRequest)
                        appUsers = try (StorageManager.shared.saveContext.fetch(AppUser.fetchRequest()) as? [AppUser])
                        
                        for user in results {
                            if let userId = user.userId {
                                self.userIdToUser[userId] = user
                            }
                        }
                        if let conversations = appUsers?.first?.conversations {
                            for conversation in conversations {
                                if let conversation = conversation as? Conversation {
                                    if let userId = conversation.participants?.userId {
                                        self.userIdToConversation[userId] = conversation
                                    }
                                    conversation.isOnline = false
                                }
                                StorageManager.shared.performSave(in: StorageManager.shared.saveContext)
                            }
                        }
                    } catch let err {
                        print(err)
                    }
                }
            //}
            
        /*} catch let err {
            print("Cant fetch All Users in ConversationListDataProvider init")
            print(err.localizedDescription)
        }*/
        
    }
    
    
}

// MARK: - Communicator Delegate
extension ConversationListDataProvider {
    
    func createConversationWith(userID: String, username: String?) {
        if userIdToConversation[userID] == nil {
            
            var result = [Conversation]()
            
            do {
                result = try  StorageManager.shared.mainContext.fetch(Conversation.requestConversationWith(conversationId: userID))
            } catch let err {
                print(err)
            }
            
            if result.count == 0 {
                StorageManager.shared.createConversation(with: userIdToUser[userID]!) { conv in
                    self.userIdToConversation[userID] = conv
                }
            } else {
                StorageManager.shared.updateConversationOnlineStatus(conversation: result[0], isOnline: true)
                userIdToConversation[userID] = result[0]
            }
            
        } else {
            StorageManager.shared.updateConversationOnlineStatus(conversation: userIdToConversation[userID]!, isOnline: true)
        }
    }
    
    func didFoundUser(userID: String, username: String?) {
        // creates or updates user's online status
        if userIdToUser[userID] == nil {
            
            let request = User.requestUserWithId(userId: userID)
            var result = [User]()
            do {
            
                result = try StorageManager.shared.mainContext.fetch(request)
            } catch let err {
                print("Cant fetch USERs with ID")
                print(err)
            }
            
            if result.count == 0 {
                //self.userIdToUser[userID] =
                //StorageManager.shared.updateUsersUsername(user: userIdToUser[userID]!, newUsername: username) {
                    StorageManager.shared.foundedNewUser(userId: userID, username: username) { user in
                        self.userIdToUser[userID] = user
                        self.createConversationWith(userID: userID, username: username)
                    }
               // }
            } else {
                StorageManager.shared.updateUsersUsername(user: userIdToUser[userID]!, newUsername: username) {
                
                    StorageManager.shared.updateUserOnlineState(user: result[0], isOnline: true)
                    self.userIdToUser[userID] = result[0]
                    self.createConversationWith(userID: userID, username: username)
                }
            }
            
        } else {
            StorageManager.shared.updateUsersUsername(user: userIdToUser[userID]!, newUsername: username) {
                StorageManager.shared.updateUserOnlineState(user: self.userIdToUser[userID], isOnline: true)
                self.createConversationWith(userID: userID, username: username)
            }
            
        }
    }
    
    func didLostUser(userID: String) {
        StorageManager.shared.updateUserOnlineState(user: userIdToUser[userID], isOnline: false)
        StorageManager.shared.updateConversationOnlineStatus(conversation: userIdToConversation[userID]!, isOnline: false)
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        self.listViewController?.onError(error: error)
    }
    
    func failedToStartAdvertising(error: Error) {
        self.listViewController?.onError(error: error)
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        if fromUser == CommunicationManager.shared.communicator.userPeerID.displayName {
            StorageManager.shared.createMessage(fromId: fromUser, toId: toUser, text: text, conversation: userIdToConversation[toUser]!)
        } else {
            StorageManager.shared.createMessage(fromId: fromUser, toId: toUser, text: text, conversation: userIdToConversation[fromUser]!)
        }
    }
    
    
}
