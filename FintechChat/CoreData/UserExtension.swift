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
        guard let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User else { return nil }
        
        return user
    }
}
