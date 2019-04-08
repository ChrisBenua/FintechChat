//
//  ConversationListModel.swift
//  FintechChat
//
//  Created by Ирина Улитина on 08/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import CoreData

protocol IConversationListModel: IUserProfileStorageManager {
    var communicator: CommunicatorDelegate { get }
}

class ConversationListModel: IConversationListModel {
    
    func getUserProfileStateSync() -> UserProfileState {
        return self.storageCoordinator.getUserProfileStateSync()
    }
    
    func saveUserProfileState(profileState: UserProfileState, completion: (() -> Void)?, in context: NSManagedObjectContext?) {
        self.storageCoordinator.saveUserProfileState(profileState: profileState, completion: completion, in: context)
    }
    
    func getUserProfileState(from context: NSManagedObjectContext?, completion: ((UserProfileState) -> Void)?) {
        self.storageCoordinator.getUserProfileState(from: context, completion: completion)
    }
    
    private var storageCoordinator: IStorageCoordinator
    
    var communicator: CommunicatorDelegate
        
    init(storage: IStorageCoordinator, communicator: CommunicatorDelegate) {
        self.storageCoordinator = storage
        self.communicator = communicator
    }
    
}
