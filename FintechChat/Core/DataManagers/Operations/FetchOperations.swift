//
//  FetchOperations.swift
//  FintechChat
//
//  Created by Ирина Улитина on 09/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

protocol FailiableOperation: class {
    var failed: Bool { get set }
}

class FetchUserProfileImageOperation: Operation, FailiableOperation {
    var fetchedImage: UIImage?
    var failed: Bool = false
    
    override func main() {
        do {
            self.fetchedImage = try FetchSaveManager.getSavedProfileImage()
        } catch let err {
            Logger.log(err.localizedDescription)
            failed = true
        }
    }
}

class FetchUsernameOperation: Operation, FailiableOperation {
    var username: String?
    var failed: Bool = false
    
    override func main() {
        do {
            self.username = try FetchSaveManager.getSavedStringFromFile(DataManagersFilePaths.userNameFile)
        } catch let err {
            Logger.log(err.localizedDescription)
            failed = true
        }
    }
}

class FetchUserDetailInfo: Operation, FailiableOperation {
    var detailInfo: String?
    var failed: Bool = false
    
    override func main() {
        do {
            self.detailInfo = try FetchSaveManager.getSavedStringFromFile(DataManagersFilePaths.userDetailInfoFile)
        } catch let err {
            Logger.log(err.localizedDescription)
            
        }
    }
}
