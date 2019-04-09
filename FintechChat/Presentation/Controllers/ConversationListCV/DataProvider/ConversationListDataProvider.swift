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
        let frc = NSFetchedResultsController(fetchRequest: Conversation.requestSortedByDateConversations(), managedObjectContext: self.model.mainContext, sectionNameKeyPath: "getSectionName", cacheName: nil)
        
        return frc
    }
    
    func generateConversationFRC(conversationId: String) -> NSFetchedResultsController<Message> {
        let frc = NSFetchedResultsController(fetchRequest: Message.requestMessagesInConversation(conversationID: conversationId), managedObjectContext: self.model.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return frc
    }
    
    var userIdToUser: [String: User] = [:]
    
    var userIdToConversation: [String: Conversation] = [:]
    
    var model: IConversationListDataProviderModel
    
    init(model: IConversationListDataProviderModel) {
        self.model = model
        let userRequest: NSFetchRequest<User> = User.fetchRequest()
        //do {
            var results: [User] = []
            var appUsers: ([AppUser]?)
            //DispatchQueue.global(qos: .background).async  {
        
                self.model.saveContext.performAndWait {
                    do {
                        
                        results = try self.model.saveContext.fetch(userRequest)
                        appUsers = try (self.model.saveContext.fetch(AppUser.fetchRequest()) as? [AppUser])
                        
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
                                self.model.stack.performSave(with: self.model.saveContext, completion: nil)
                                //self.model.stack.performSave(in: StorageManager.shared.saveContext)
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
                result = try  self.model.mainContext.fetch(Conversation.requestConversationWith(conversationId: userID))
            } catch let err {
                print(err)
            }
            
            if result.count == 0 {
                self.model.createConversation(with: userIdToUser[userID]!) { conv in
                    self.userIdToConversation[userID] = conv
                }
            } else {
                self.model.updateConversationOnlineStatus(conversation: result[0], isOnline: true)
                userIdToConversation[userID] = result[0]
            }
            
        } else {
            self.model.updateConversationOnlineStatus(conversation: userIdToConversation[userID]!, isOnline: true)
        }
    }
    
    func didFoundUser(userID: String, username: String?) {
        // creates or updates user's online status
        if userIdToUser[userID] == nil {
            
            let request = User.requestUserWithId(userId: userID)
            var result = [User]()
            do {
            
                result = try self.model.mainContext.fetch(request)
            } catch let err {
                print("Cant fetch USERs with ID")
                print(err)
            }
            
            if result.count == 0 {
                //self.userIdToUser[userID] =
                //StorageManager.shared.updateUsersUsername(user: userIdToUser[userID]!, newUsername: username) {
                    self.model.foundedNewUser(userId: userID, username: username) { user in
                        self.userIdToUser[userID] = user
                        self.createConversationWith(userID: userID, username: username)
                    }
               // }
            } else {
                self.model.updateUsersUsername(user: userIdToUser[userID]!, newUsername: username) {
                
                    self.model.updateUserOnlineState(user: result[0], isOnline: true)
                    self.userIdToUser[userID] = result[0]
                    self.createConversationWith(userID: userID, username: username)
                }
            }
            
        } else {
            self.model.updateUsersUsername(user: userIdToUser[userID]!, newUsername: username) {
                self.model.updateUserOnlineState(user: self.userIdToUser[userID], isOnline: true)
                self.createConversationWith(userID: userID, username: username)
            }
            
        }
    }
    
    func didLostUser(userID: String) {
        self.model.updateUserOnlineState(user: userIdToUser[userID], isOnline: false)
        self.model.updateConversationOnlineStatus(conversation: userIdToConversation[userID]!, isOnline: false)
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        self.listViewController?.onError(error: error)
    }
    
    func failedToStartAdvertising(error: Error) {
        self.listViewController?.onError(error: error)
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        if fromUser == self.model.getCurrentUserId() {
            self.model.createMessage(fromId: fromUser, toId: toUser, text: text, conversation: userIdToConversation[toUser]!)
        } else {
            self.model.createMessage(fromId: fromUser, toId: toUser, text: text, conversation: userIdToConversation[fromUser]!)
        }
    }
    
    
}
