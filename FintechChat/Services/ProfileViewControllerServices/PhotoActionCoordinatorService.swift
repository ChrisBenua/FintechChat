//
//  PhotoActionCoordinatorService.swift
//  FintechChat
//
//  Created by Ирина Улитина on 05/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import AVFoundation

protocol IPhotoActionCoordinatorSerice {
    func logoAlertController(sourceView: (UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate)) -> UIAlertController
}

class PhotoActionCoordinatorService: IPhotoActionCoordinatorSerice {
    
    func logoAlertController(sourceView: (UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate)) -> UIAlertController {
        let pickImageAlertController = UIAlertController(title: "Выберите фото", message: nil, preferredStyle: .actionSheet)
        
        let selectFromGalleryAction = selectFromGalleryService.selectFromGalleryAction(sourceView: sourceView)
        
        let takePhotoAction = photoActionService.takePhotoAction(sourceView: sourceView)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { [weak pickImageAlertController] (_) in
            pickImageAlertController?.dismiss(animated: true, completion: nil)
        }
        
        pickImageAlertController.addAction(selectFromGalleryAction)
        pickImageAlertController.addAction(takePhotoAction)
        pickImageAlertController.addAction(cancelAction)
        
        return pickImageAlertController
    }
    
    private var imagePickerService: IImagePickerService
    
    private var cameraAccessService: ICameraAccessService
    
    private var selectFromGalleryService: ISelectFromGalleryService
    
    private var photoActionService: IPhotoActionService
    
    init(imageService: IImagePickerService, cameraService: ICameraAccessService, galleryService: ISelectFromGalleryService, photoActionService: IPhotoActionService) {
        self.imagePickerService = imageService
        self.cameraAccessService = cameraService
        self.selectFromGalleryService = galleryService
        self.photoActionService = photoActionService
    }
    
}
