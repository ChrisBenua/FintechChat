//
//  UserExtension.swift
//  FintechChat
//
//  Created by Ирина Улитина on 28/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import CoreData

extension User {
    static func insertUser(into context: NSManagedObjectContext) -> User? {
        var res: User?
        context.performAndWait {
            guard let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User else { return }
            
            res = user
        }
        return res
    }
    
    static func onlineUsersFetchRequest() -> NSFetchRequest<User> {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "isOnline == true")
        
        return request
    }
    
    static func fetchUserWithId(userId: String) -> NSFetchRequest<User> {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", userId)
        
        return request
    }
}
