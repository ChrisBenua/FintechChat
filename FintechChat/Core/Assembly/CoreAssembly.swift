//
//  CoreAssembly.swift
//  FintechChat
//
//  Created by Ирина Улитина on 05/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    
    var communicator: (ICommunicationManager) { get set }
    
    var storageCoordinator: IStorageCoordinator { get set }
}

class CoreAssembly: ICoreAssembly {
    
    var communicator: (ICommunicationManager)
    
    var storageCoordinator: IStorageCoordinator = StorageManager()
    
    init() {
        let state = self.storageCoordinator.getUserProfileStateSync()
        self.communicator = CommunicationManager(username: state.username ?? "justUsername")
    }
    
}
