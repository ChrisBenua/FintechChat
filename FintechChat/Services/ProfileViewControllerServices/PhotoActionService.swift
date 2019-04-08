//
//  PhotoActionService.swift
//  FintechChat
//
//  Created by Ирина Улитина on 05/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import AVFoundation

protocol IPhotoActionService {
    func takePhotoAction(sourceView: (UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate)) -> UIAlertAction
}

class PhotoActionService: IPhotoActionService {
    func takePhotoAction(sourceView: (UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate)) -> UIAlertAction {
        let takePhotoAction = UIAlertAction(title: "Сделать фото", style: .default) { (_) in
            let res = self.cameraAccessService.checkAccessToCamera()
            if res.0 {
                
                let picker = self.imagePickerService.getDefaultImagePicker(delegate: sourceView)
                picker.sourceType = UIImagePickerController.SourceType.camera
                //if let picker = picker {
                sourceView.present(picker, animated: true, completion: nil)
                //}
            } else {
                if let controller = res.1 {
                    sourceView.present(controller, animated: true)
                }
            }
        }
        
        return takePhotoAction
    }
    
    private var cameraAccessService: ICameraAccessService
    
    private var imagePickerService: IImagePickerService
    
    init(cameraService: ICameraAccessService, imageService: IImagePickerService) {
        self.cameraAccessService = cameraService
        self.imagePickerService = imageService
    }
    
}
