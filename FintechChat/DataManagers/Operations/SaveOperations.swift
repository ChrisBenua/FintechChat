//
//  OperationDataManager.swift
//  FintechChat
//
//  Created by Ирина Улитина on 09/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

class SaveProfileImageOperation: Operation, FailiableOperation {
    
    var failed: Bool = false
    
    var profileImage: UIImage?
    
    init(_ profileImage: UIImage?) {
        self.profileImage = profileImage
    }
    
    override func main() {
        if let image = profileImage {
            
            do {
                try FetchSaveManager.saveProfileImageToFile(profileImage: image, DataManagersFilePaths.userProfileImageFile)
            } catch let err {
                Logger.log(err.localizedDescription)
                failed = true
            }
        }
    }
}


class SaveUsernameOperation: Operation, FailiableOperation {
    
    var failed: Bool = false
    
    var username: String?
    
    init(_ username: String?) {
        self.username = username
    }
    
    override func main() {
        if let name = username {
            do {
                try FetchSaveManager.saveStringToFile(text: name, DataManagersFilePaths.userNameFile)
            } catch let err {
                failed = true
                Logger.log(err.localizedDescription)
            }
        }
    }
}

class SaveDetailInfoOperation: Operation, FailiableOperation {
    
    var failed: Bool = false
    
    var detailInfo: String?
    
    init(_ detailInfo: String?) {
        self.detailInfo = detailInfo
    }
    
    override func main() {
        if let info = detailInfo {
            do {
                try FetchSaveManager.saveStringToFile(text: info, DataManagersFilePaths.userDetailInfoFile)
            } catch let err {
                failed = true
                Logger.log(err.localizedDescription)
            }
        }
    }
}
