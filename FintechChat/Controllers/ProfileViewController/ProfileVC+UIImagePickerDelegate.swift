//
//  ProfileVC+UIImagePickerDelegate.swift
//  FintechChat
//
//  Created by Ирина Улитина on 18/02/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

//MARK: UIImagePickerControllerDelegate
extension ProfileViewController : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        self.profilePhotoImageView.image = chosenImage
        
        //to be sure that ImagePickerController will be dismissed
        defer {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


