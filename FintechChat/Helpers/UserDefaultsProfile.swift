//
//  UserDefaultsProfile.swift
//  FintechChat
//
//  Created by Ирина Улитина on 08/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

extension UserDefaults {
    static var userProfileImageKey = "UserProfileImageKey"
    static var userNameKey = "UserNameKey"
    static var userDetailInfoKey = "UserDetailInfoKey"
    static var savingQueue = DispatchQueue(label: "savingUserProfileTouserDefaults.queue", qos: .background, attributes: .concurrent)
    
    
    /*static func saveUserProfileInfoGCD(profileImage: UIImage, username: String, userDetailInfo: String, onComplete: @escaping () -> ()) {
        
        let group = DispatchGroup()
        
        group.enter()
        savingQueue.async {
            saveToUserDefaults(objectToSave: profileImage, key: UserDefaults.userProfileImageKey)
            group.leave()
        }
        
        group.enter()
        savingQueue.async {
            saveToUserDefaults(objectToSave: username, key: UserDefaults.userNameKey)
            group.leave()
        }
        
        group.enter()
        savingQueue.async {
            saveToUserDefaults(objectToSave: userDetailInfo, key: UserDefaults.userDetailInfoKey)
            group.leave()
        }
        
        group.notify(queue: savingQueue) {
            onComplete()
        }
        
    }
    
    //static func loadUserProfileInfoGCD
    
    static func saveToUserDefaults<T>(objectToSave: T, key: String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: objectToSave)
        UserDefaults.standard.set(data, forKey: key)
    }
    
    static func getFromUserDefaults<T>(key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        guard let convertedObject = NSKeyedUnarchiver.unarchiveObject(with: data) as? T else { return nil }
        return convertedObject
    }*/
}
