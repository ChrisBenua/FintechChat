//
//  OperationDataManager.swift
//  FintechChat
//
//  Created by Ирина Улитина on 09/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

class OperationDataManager: UserProfileDataDriver {
    public static var shared: UserProfileDataDriver = OperationDataManager()
    private var operationQueue = OperationQueue()
    private var savingOperationQueue = OperationQueue()
    
    func saveUserProfileInfo(state: UserProfileState, onComplete: @escaping () -> Void, onError: @escaping () -> Void) {
        let task1 = SaveProfileImageOperation(state.profileImage)
        let task2 = SaveUsernameOperation(state.username)
        let task3 = SaveDetailInfoOperation(state.detailInfo)
        
        let notifyOperation = NotifyOperation([task1, task2, task3])
        
        notifyOperation.addDependency(task1)
        notifyOperation.addDependency(task2)
        notifyOperation.addDependency(task3)
        
        operationQueue.addOperation(task1)
        operationQueue.addOperation(task2)
        operationQueue.addOperation(task3)
        operationQueue.addOperation(notifyOperation)
        
        notifyOperation.completionBlock = {
            if notifyOperation.failed {
                onError()
            } else {
                onComplete()
            }
        }
    }
    
    func getUserProfileInfo(onComplete: @escaping (UserProfileState) -> Void) {
        let task1 = FetchUserProfileImageOperation()
        let task2 = FetchUserDetailInfo()
        let task3 = FetchUsernameOperation()
        let tasks = [task1, task2, task3]
        
        let notifyOperation = NotifyOperation(tasks.compactMap({ (operation) -> FailiableOperation in
            if let operation = operation as? FailiableOperation {
                return operation
            } else {
                fatalError()
            }
        }))
        
        for dependencyOperation in tasks {
            notifyOperation.addDependency(dependencyOperation)
        }
        
        for task in tasks {
            savingOperationQueue.addOperation(task)
        }
        savingOperationQueue.addOperation(notifyOperation)
        
        notifyOperation.completionBlock = {
            onComplete(UserProfileState(username: task3.username, profileImage: task1.fetchedImage, detailInfo: task2.detailInfo))
        }
    }
}
