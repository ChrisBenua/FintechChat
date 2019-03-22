//
//  StorageManager.swift
//  FintechChat
//
//  Created by Ирина Улитина on 22/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import CoreData

class StorageManager {
    public static var shared = StorageManager()
    
    private var stack: CoreDataStack
    
    init() {
        stack = CoreDataStack()
    }
    
    public func saveUserProfileState(profileState: UserProfileState, completion: (() ->())?, in context: NSManagedObjectContext? = nil) {
        let context = context ?? self.stack.saveContext
        let user = AppUser.getOrCreateAppUser(in: context)
        self.stack.saveContext.perform {
            user?.username = profileState.username
            user?.detailInfo = profileState.detailInfo
            user?.profileImage = profileState.profileImage?.pngData()
            user?.timestamp = Date()
            self.stack.performSave(with: context, completion: completion)
        }
        
    }
    
    public func getUserProfileState(from context: NSManagedObjectContext? = nil) -> UserProfileState {
        let context = context ?? self.stack.mainContext
        let user = AppUser.getOrCreateAppUser(in: context)
        self.stack.performSave(with: context, completion: nil)
        
        
        
        return UserProfileState(username: user?.username, profileImage: UIImage(data: user?.profileImage ?? UserProfileState.defaultImageData), detailInfo: user?.detailInfo)
    }
}
