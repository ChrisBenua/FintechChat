//
//  UserProfileStorageManager.swift
//  FintechChat
//
//  Created by Ирина Улитина on 04/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import CoreData

class UserProfileStorageManager: IUserProfileStorageManager {
    func saveUserProfileState(profileState: UserProfileState, completion: (() -> Void)?, in context: NSManagedObjectContext?) {
        let context = context ?? self.stack.saveContext
        DispatchQueue.global(qos: .background).async {
            AppUser.getOrCreateAppUser(in: context) { user in
                
                context.performAndWait {
                    user?.username = profileState.username
                    user?.detailInfo = profileState.detailInfo
                    user?.profileImage = profileState.profileImage?.pngData()
                    user?.timestamp = Date()
                    self.stack.performSave(with: context, completion: completion)
                }
                
            }
        }
    }
    
    func getUserProfileState(from context: NSManagedObjectContext?, completion: ((UserProfileState) -> Void)?) {
        let context = context ?? self.stack.saveContext
        DispatchQueue.global(qos: .background).async {
            AppUser.getOrCreateAppUser(in: context) { user in
                user?.managedObjectContext!.performAndWait {
                    user?.username = user?.username ?? "Кристиан Бенуа"
                }
                self.stack.performSave(with: context) {
                    user?.managedObjectContext?.performAndWait {
                        completion?(UserProfileState(username: user?.username, profileImage: UIImage(data: user?.profileImage ?? UserProfileState.defaultImageData), detailInfo: user?.detailInfo))
                    }
                    
                }
            }
        }
    }
    
    var stack: ICoreDataStack
    
    var saveContext: NSManagedObjectContext {
        get {
            return self.stack.saveContext
        }
    }
    
    var mainContext: NSManagedObjectContext {
        get {
            return self.stack.mainContext
        }
    }
    
    init(stack: ICoreDataStack) {
        self.stack = stack
    }
}
