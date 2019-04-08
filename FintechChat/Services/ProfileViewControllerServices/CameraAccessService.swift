//
//  CameraAccessService.swift
//  FintechChat
//
//  Created by Ирина Улитина on 05/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

protocol ICameraAccessService {
    func checkAccessToCamera() -> (Bool, UIAlertController?)
}

class CameraAccessService: ICameraAccessService {
    func checkAccessToCamera() -> (Bool, UIAlertController?) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            let noCameraAlert = UIAlertController(title: "Ошибка", message: "Камера не найдена", preferredStyle: .alert)
            
            noCameraAlert.addAction(.okAction)
            
            //self.present(noCameraAlert, animated: true)
            return (false, noCameraAlert)
        } else if AVCaptureDevice.authorizationStatus(for: .video) != .authorized {
            let noAccessAlert = UIAlertController(title: "Беда", message: "Нет доступа к камере, дайте разрешение в настройках", preferredStyle: .alert)
            noAccessAlert.addAction(.okAction)
            //self.present(noAccessAlert, animated: true)
            return (false, noAccessAlert)
        }
        return (true, nil)
    }
    
    
}
