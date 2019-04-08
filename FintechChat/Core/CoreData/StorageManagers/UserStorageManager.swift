//
//  UserStorageManager.swift
//  FintechChat
//
//  Created by Ирина Улитина on 04/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import CoreData

class UserStorageManager: IUsersStorageManager {
    func updateUsersUsername(user: User, newUsername: String?, completion: (() -> Void)?) {
        DispatchQueue.global(qos: .background).async {
            Logger.log("UPDATE USERNAME")
            let userObjectId = user.objectID
            
            if let username = newUsername {
                self.saveContext.performAndWait {
                    let saveContextUser = self.saveContext.object(with: userObjectId) as? User
                    saveContextUser?.name = username
                    
                    self.stack.performSave(with: self.saveContext, completion: completion)
                }
            }
        }
    }
    
    func foundedNewUser(userId: String, username: String?, completion: @escaping (User) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let user = User.insertUser(into: self.saveContext)
            self.saveContext.performAndWait {
                user?.userId = userId
                user?.isOnline = true
                user?.name = username
                self.stack.performSave(with: self.saveContext) {
                    DispatchQueue.main.async {
                        completion(user!)
                    }
                }
            }
        }
    }
    
    func updateUserOnlineState(user: User?, isOnline: Bool) {
        DispatchQueue.global(qos: .background).async {
            guard let userObjectId = user?.objectID else { return }
            
            self.saveContext.performAndWait {
                let saveContextUser = self.saveContext.object(with: userObjectId) as? User
                saveContextUser?.isOnline = isOnline
                DispatchQueue.main.async {
                    self.stack.performSave(with: self.saveContext, completion: nil)
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
