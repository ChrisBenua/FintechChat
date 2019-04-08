//
//  ServiceAssembly.swift
//  FintechChat
//
//  Created by Ирина Улитина on 05/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import CoreData

//Additional protocols, because presentation layer cant communicate with core layer
protocol IServiceAssembly: IMessageStorageManager, IConversationStorageManager, IUsersStorageManager, IUserProfileStorageManager {
    var themesService: IThemeViewControllerService { get set }
    
    var imagePickerService: IImagePickerService { get set }
    
    var cameraAccessService: ICameraAccessService { get set }
    
    var photoActionService: IPhotoActionService { get set }
    
    var photoActionCoordinator: IPhotoActionCoordinatorSerice { get set }
    
    var selectFromGalleryService: ISelectFromGalleryService { get set }
    
    var retryAlertService: IRetryAlertControllerService { get set }
    
    var storageCoordinator: IStorageCoordinator { get }
    
    var communicator: ICommunicationManager { get set }
}

class ServiceAssembly: IServiceAssembly {
    
    var communicator: ICommunicationManager
    
    func getUserProfileStateSync() -> UserProfileState {
        return self.storageCoordinator.getUserProfileStateSync()
    }
    
    func createConversation(with user: User, completion: @escaping (Conversation) -> Void) {
        self.coreAssembly.storageCoordinator.createConversation(with: user, completion: completion)
    }
    
    func updateConversationOnlineStatus(conversation: Conversation, isOnline: Bool) {
        self.coreAssembly.storageCoordinator.updateConversationOnlineStatus(conversation: conversation, isOnline: isOnline)
    }
    
    func fetchConversation(withId: String) -> Conversation? {
        return self.coreAssembly.storageCoordinator.fetchConversation(withId: withId)
    }
    
    func updateUsersUsername(user: User, newUsername: String?, completion: (() -> Void)?) {
        self.coreAssembly.storageCoordinator.updateUsersUsername(user: user, newUsername: newUsername, completion: completion)
    }
    
    func foundedNewUser(userId: String, username: String?, completion: @escaping (User) -> Void) {
        self.coreAssembly.storageCoordinator.foundedNewUser(userId: userId, username: username, completion: completion)
    }
    
    func updateUserOnlineState(user: User?, isOnline: Bool) {
        self.coreAssembly.storageCoordinator.updateUserOnlineState(user: user, isOnline: isOnline)
    }
    
    func saveUserProfileState(profileState: UserProfileState, completion: (() -> Void)?, in context: NSManagedObjectContext?) {
        self.coreAssembly.storageCoordinator.saveUserProfileState(profileState: profileState, completion: completion, in: context)
    }
    
    func getUserProfileState(from context: NSManagedObjectContext?, completion: ((UserProfileState) -> Void)?) {
        self.coreAssembly.storageCoordinator.getUserProfileState(from: context, completion: completion)
    }
    
    func createMessage(fromId: String, toId: String, text: String, conversation: Conversation) {
        self.coreAssembly.storageCoordinator.createMessage(fromId: fromId, toId: toId, text: text, conversation: conversation)
    }
    
    func markAsReadMessages(in conversation: Conversation) {
        self.coreAssembly.storageCoordinator.markAsReadMessages(in: conversation)
    }
    
    var stack: ICoreDataStack {
        get {
            return self.coreAssembly.storageCoordinator.stack
        }
    }
    
    var saveContext: NSManagedObjectContext {
        get {
            return self.coreAssembly.storageCoordinator.stack.saveContext
        }
    }
    
    var mainContext: NSManagedObjectContext {
        get {
            return self.coreAssembly.storageCoordinator.stack.mainContext
        }
    }
    
    
    private let coreAssembly: ICoreAssembly
    
    var storageCoordinator: IStorageCoordinator {
        get {
            return self.coreAssembly.storageCoordinator
        }
    }
    
    lazy var themesService: IThemeViewControllerService = ThemeViewControllerService()
    
    lazy var imagePickerService: IImagePickerService = ImagePickerService()
    
    lazy var cameraAccessService: ICameraAccessService = CameraAccessService()
    
    lazy var photoActionService: IPhotoActionService = PhotoActionService(cameraService: self.cameraAccessService, imageService: self.imagePickerService)
    
    lazy var photoActionCoordinator: IPhotoActionCoordinatorSerice = PhotoActionCoordinatorService(imageService: self.imagePickerService, cameraService: self.cameraAccessService, galleryService: self.selectFromGalleryService, photoActionService: self.photoActionService)
    
    lazy var selectFromGalleryService: ISelectFromGalleryService = SelectFromGalleryService(pickerService: self.imagePickerService)
    
    lazy var retryAlertService: IRetryAlertControllerService = RetryAlertControllerService()
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
        self.communicator = self.coreAssembly.communicator
    }
    
}
