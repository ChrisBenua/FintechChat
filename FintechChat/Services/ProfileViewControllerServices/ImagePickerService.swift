//
//  ImagePickerService.swift
//  FintechChat
//
//  Created by Ирина Улитина on 05/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

protocol IImagePickerService {
    func getDefaultImagePicker(delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)) -> UIImagePickerController
}

class ImagePickerService: IImagePickerService {
    func getDefaultImagePicker(delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = delegate
        imagePicker.allowsEditing = true
        return imagePicker
    }
    
    
}
