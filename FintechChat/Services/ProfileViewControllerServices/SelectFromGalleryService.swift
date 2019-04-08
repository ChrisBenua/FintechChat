//
//  SelectFromGalleryService.swift
//  FintechChat
//
//  Created by Ирина Улитина on 05/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import AVFoundation

protocol ISelectFromGalleryService {
    func selectFromGalleryAction(sourceView: (UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate)) -> UIAlertAction
}

class SelectFromGalleryService: ISelectFromGalleryService {
    func selectFromGalleryAction(sourceView: (UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate)) -> UIAlertAction {
        let selectFromGalleryAction = UIAlertAction(title: "Из Галлереи", style: .default) { (_) in
            let picker = self.imagePickerService.getDefaultImagePicker(delegate: sourceView)
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            //if let picker = picker {
            sourceView.present(picker, animated: true, completion: nil)
            //}
        }
        return selectFromGalleryAction
    }
    
    private var imagePickerService: IImagePickerService
    
    init(pickerService: IImagePickerService) {
        self.imagePickerService = pickerService
    }
    
}
