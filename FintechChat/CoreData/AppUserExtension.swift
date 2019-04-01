//
//  AppUserExtension.swift
//  FintechChat
//
//  Created by Ирина Улитина on 22/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import CoreData


extension AppUser {
    
    
    static func insertAppUser(into context: NSManagedObjectContext) -> AppUser? {
        guard let appUser = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: context) as? AppUser else { return nil }
        
        return appUser
    }
    
    static func getOrCreateAppUserSync(in context: NSManagedObjectContext) -> AppUser? {
        let fetchRequest: NSFetchRequest<AppUser> = AppUser.fetchRequest()
        var foundUser: AppUser? = nil
        
        
        context.performAndWait {
            do {
                
                let result = try context.fetch(fetchRequest)
                if let user = result.first {
                    foundUser = user
                }
            } catch let err {
                print("Error in fetching \(err)")
            }
            if foundUser == nil {
                foundUser = AppUser.insertAppUser(into: context)
            }
        }
        return foundUser
    }
    
    static func getOrCreateAppUser(in context: NSManagedObjectContext, completion: ((AppUser?) -> ())?) {
        
        DispatchQueue.global(qos: .background).async  {
            let fetchRequest: NSFetchRequest<AppUser> = AppUser.fetchRequest()
            var foundUser: AppUser? = nil
            
            
            context.perform {
                do {
                    
                    let result = try context.fetch(fetchRequest)
                    if let user = result.first {
                        foundUser = user
                    }
                } catch let err {
                    print("Error in fetching \(err)")
                }
                if foundUser == nil {
                    foundUser = AppUser.insertAppUser(into: context)
                }
                DispatchQueue.main.async {
                    completion?(foundUser)
                }
            }

        }
        
        
    }
}

