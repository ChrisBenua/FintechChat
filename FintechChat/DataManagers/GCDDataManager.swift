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

protocol UserProfileDataDriver: class {
    static var shared: UserProfileDataDriver { get set }
    
    func saveUserProfileInfo(state: UserProfileState, onComplete: @escaping () -> (),
                             onError: @escaping () -> ())
    
    func getUserProfileInfo(onComplete: @escaping (UserProfileState) -> ())
}

class GCDDataManager: UserProfileDataDriver {
    
    private var savingQueue = DispatchQueue(label: "savingUserProfileToFiles.queue", qos: .background, attributes: .concurrent)
    
    private var loadingQueue = DispatchQueue(label: "loadingUserProfileToFiles.queue", qos: .background, attributes: .concurrent)
    
    public static var shared: UserProfileDataDriver = GCDDataManager()
    
    func saveUserProfileInfo(state: UserProfileState, onComplete: @escaping () -> (), onError: @escaping () -> ()) {
        
        let group = DispatchGroup()
        if (state.detailInfo != nil) {
            group.enter()
            savingQueue.async {
                do {
                    try FetchSaveManager.saveStringToFile(text: state.detailInfo!, DataManagersFilePaths.userDetailInfoFile)
                    group.leave()
                } catch let err {
                    Logger.log(err.localizedDescription)
                    onError()
                    group.leave()
                    return
                }
            }
        }
        
        if (state.username != nil) {
            group.enter()
            savingQueue.async {
                do {
                    try FetchSaveManager.saveStringToFile(text: state.username!, DataManagersFilePaths.userNameFile)
                    group.leave()
                } catch let err {
                    Logger.log(err.localizedDescription)
                    onError()
                    group.leave()
                    return
                }
            }
        }
        
        if (state.profileImage != nil) {
            group.enter()
            savingQueue.async {
                do {
                    try FetchSaveManager.saveProfileImageToFile(profileImage: state.profileImage!, DataManagersFilePaths.userProfileImageFile)
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
    
    func getUserProfileInfo(onComplete: @escaping (UserProfileState) -> ()) {
        let group = DispatchGroup()
        var image: UIImage?
        var username: String?
        var detailInfo: String?
        
        group.enter()
        loadingQueue.async {
            do {
                image = try FetchSaveManager.getSavedProfileImage()
                group.leave()
            } catch let err {
                Logger.log(err.localizedDescription)
                group.leave()
            }
        }
        
        group.enter()
        loadingQueue.async {
            do {
                username = try FetchSaveManager.getSavedStringFromFile(DataManagersFilePaths.userNameFile)
                group.leave()
            } catch let err {
                Logger.log(err.localizedDescription)
                group.leave()
            }
        }
        
        group.enter()
        loadingQueue.async {
            do {
                detailInfo = try FetchSaveManager.getSavedStringFromFile(DataManagersFilePaths.userDetailInfoFile)
                group.leave()
            } catch let err {
                Logger.log(err.localizedDescription)
                group.leave()
            }
        }
        
        group.notify(queue: loadingQueue) {
            onComplete(UserProfileState(username: username, profileImage: image, detailInfo: detailInfo))
            
        }
        
    }
    
    
}
