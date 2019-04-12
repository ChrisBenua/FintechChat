//
//  ProfileModel.swift
//  FintechChat
//
//  Created by Ирина Улитина on 08/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//
import CoreData
import Foundation

protocol IProfileModel: IImagePickerService, ICameraAccessService, IPhotoActionService, IPhotoActionCoordinatorSerice, ISelectFromGalleryService, IRetryAlertControllerService, IUserProfileStorageManager {
    var imagePickerService: IImagePickerService { get set }
    
    var cameraAccessService: ICameraAccessService { get set }
    
    var photoActionService: IPhotoActionService { get set }
    
    var photoActionCoordinator: IPhotoActionCoordinatorSerice { get set }
    
    var selectFromGalleryService: ISelectFromGalleryService { get set }
    
    var retryAlertService: IRetryAlertControllerService { get set }
    
    var communicator: ICommunicationManager { get }
    
    var imageDownloadingService: IImageDownloadingService { get }
    
    func downloadImageFor(item: IPixabyImageInfo?, completion: @escaping (UIImage?) -> Void)
}

class ProfileModel: IProfileModel {
    var imageDownloadingService: IImageDownloadingService
    
    var presentationAssembly: IPresentationAssembly!
    
    func downloadImageFor(item: IPixabyImageInfo?, completion: @escaping (UIImage?) -> Void) {
        if let url = item?.fullImageUrl {
            self.imageDownloadingService.downloadImage(forUrl: url, completion: completion)
        }
    }
    
    func getDefaultImagePicker(delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)) -> UIImagePickerController {
        return self.imagePickerService.getDefaultImagePicker(delegate: delegate)
    }
    
    func checkAccessToCamera() -> (Bool, UIAlertController?) {
        return self.cameraAccessService.checkAccessToCamera()
    }
    
    func takePhotoAction(sourceView: (UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate)) -> UIAlertAction {
        return self.photoActionService.takePhotoAction(sourceView: sourceView)
    }
    
    func logoAlertController(sourceView: (UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate)) -> UIAlertController {
        return self.photoActionCoordinator.logoAlertController(sourceView: sourceView)
    }
    
    func selectFromGalleryAction(sourceView: (UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate)) -> UIAlertAction {
        return self.selectFromGalleryService.selectFromGalleryAction(sourceView: sourceView)
    }
    
    func generateRetryAlertController(retryFunc: @escaping (Any?) -> Void?) -> UIAlertController {
        return self.retryAlertService.generateRetryAlertController(retryFunc: retryFunc)
    }
    
    var imagePickerService: IImagePickerService
    
    var cameraAccessService: ICameraAccessService
    
    var photoActionService: IPhotoActionService
    
    var photoActionCoordinator: IPhotoActionCoordinatorSerice
    
    var selectFromGalleryService: ISelectFromGalleryService
    
    var retryAlertService: IRetryAlertControllerService
    
    var communicator: ICommunicationManager
    
    private var storage: IUserProfileStorageManager
    
    init(imagePicker: IImagePickerService, cameraService: ICameraAccessService, photoService: IPhotoActionService, galleryService: ISelectFromGalleryService, retryService: IRetryAlertControllerService, storage: IUserProfileStorageManager, photoActionCoordinator: IPhotoActionCoordinatorSerice, communicator: ICommunicationManager, imageDownloadingService: IImageDownloadingService) {
        self.imagePickerService = imagePicker
        self.cameraAccessService = cameraService
        self.photoActionService = photoService
        self.selectFromGalleryService = galleryService
        self.retryAlertService = retryService
        self.storage = storage
        self.photoActionCoordinator = photoActionCoordinator
        self.communicator = communicator
        self.imageDownloadingService = imageDownloadingService
    }
    
    func saveUserProfileState(profileState: UserProfileState, completion: (() -> Void)?, in context: NSManagedObjectContext?) {
        self.storage.saveUserProfileState(profileState: profileState, completion: completion, in: context)
    }
    
    func getUserProfileStateSync() -> UserProfileState {
        return self.storage.getUserProfileStateSync()
    }
    
    func getUserProfileState(from context: NSManagedObjectContext?, completion: ((UserProfileState) -> Void)?) {
        self.storage.getUserProfileState(from: context, completion: completion)
    }
}
