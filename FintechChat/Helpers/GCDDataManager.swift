//
//  GCDDataManager.swift
//  FintechChat
//
//  Created by Ирина Улитина on 08/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation

enum SavingErrors: Error {
    case directoryNotFound
}

class DataManagersFilePaths {
    static var userProfileImageFile = "UserProfileImageKey.jpg"
    static var userNameFile = "UserNameKey.txt"
    static var userDetailInfoFile = "UserDetailInfoKey.txt"
}

class GCDDataManager {
    private var savingQueue = DispatchQueue(label: "savingUserProfileToFiles.queue", qos: .background, attributes: .concurrent)
    
    private var loadingQueue = DispatchQueue(label: "loadingUserProfileToFiles.queue", qos: .background, attributes: .concurrent)
    
    public static let shared: GCDDataManager = GCDDataManager()
    
    func saveUserProfileInfo(profileImage: UIImage?, username: String?, userDetailInfo: String?, onComplete: @escaping () -> (), onError: @escaping () -> ()) {
        
        let group = DispatchGroup()
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            onError()
            return
        }
        if (userDetailInfo != nil) {
            group.enter()
            savingQueue.async {
                do {
                    let fileURL = dir.appendingPathComponent(DataManagersFilePaths.userDetailInfoFile)
                    try self.saveStringToFile(text: userDetailInfo!, filePath: fileURL)
                    group.leave()
                } catch let err {
                    Logger.log(err.localizedDescription)
                    onError()
                    group.leave()
                    return
                }
            }
        }
        
        if (username != nil) {
            group.enter()
            savingQueue.async {
                do {
                    let fileURL = dir.appendingPathComponent(DataManagersFilePaths.userNameFile)
                    try self.saveStringToFile(text: username!, filePath: fileURL)
                    group.leave()
                } catch let err {
                    Logger.log(err.localizedDescription)
                    onError()
                    group.leave()
                    return
                }
            }
        }
        
        if (profileImage != nil) {
            group.enter()
            savingQueue.async {
                do {
                    let fileURL = dir.appendingPathComponent(DataManagersFilePaths.userProfileImageFile)
                    try self.saveProfileImageToFile(profileImage: profileImage!, filePath: fileURL)
                    group.leave()
                } catch let err {
                    Logger.log(err.localizedDescription)
                    onError()
                    group.leave()
                    return
                }
            }
            
        }
        group.notify(queue: savingQueue) {
            onComplete()
        }
    
    }
    
    func getUserProfileInfo(onComplete: @escaping (String?, String?, UIImage?) -> ()) {
        let group = DispatchGroup()
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        var image: UIImage?
        var username: String?
        var detailInfo: String?
        
        group.enter()
        loadingQueue.async {
            do {
                image = try self.getSavedProfileImage()
                group.leave()
            } catch let err {
                Logger.log(err.localizedDescription)
                group.leave()
            }
        }
        
        group.enter()
        loadingQueue.async {
            do {
                username = try self.getSavedStringFromFile(filePath: dir.appendingPathComponent(DataManagersFilePaths.userNameFile))
                group.leave()
            } catch let err {
                Logger.log(err.localizedDescription)
                group.leave()
            }
        }
        
        group.enter()
        loadingQueue.async {
            do {
                detailInfo = try self.getSavedStringFromFile(filePath: dir.appendingPathComponent(DataManagersFilePaths.userDetailInfoFile))
                group.leave()
            } catch let err {
                Logger.log(err.localizedDescription)
                group.leave()
            }
        }
        
        group.notify(queue: loadingQueue) {
            onComplete(detailInfo, username, image)
        }
        
    }
    
    func saveStringToFile(text: String, filePath: URL) throws {
        try text.write(to: filePath, atomically: false, encoding: .utf8)
    }
    
    func saveProfileImageToFile(profileImage: UIImage, filePath: URL) throws {
        try profileImage.jpegData(compressionQuality: 1.0)?.write(to: filePath)
    }
    
    func getSavedStringFromFile(filePath: URL) throws -> String {
        return try String(contentsOf: filePath, encoding: .utf8)
    }
    
    func getSavedProfileImage() throws -> UIImage? {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw SavingErrors.directoryNotFound
        }
        let data = try Data(contentsOf: dir.appendingPathComponent(DataManagersFilePaths.userProfileImageFile))
        
        return UIImage(data: data)
    }
}
