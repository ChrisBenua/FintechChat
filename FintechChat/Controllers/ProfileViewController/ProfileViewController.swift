//
//  ViewController.swift
//  FintechChat
//
//  Created by Ирина Улитина on 07/02/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import UIKit
import AVFoundation

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var detailInfoLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //Unexpectedly found nil while unwrapping an Optional value
        //Это потому, что в init() еще не вызвался loadView(), который
        //прикрепляет IBOutlet'ы к вьюхам на storyboard
        //Logger.debugOutput(editProfileButton.frame.debugDescription)
    }
    
    fileprivate func makeCorners() {
        let cornerRadius = imageContainerView.frame.width / 2
        
        imageContainerView.layer.cornerRadius = cornerRadius
        profilePhotoImageView.layer.cornerRadius = cornerRadius
    }
    
    fileprivate func SetupUI() {
        backButton.addTarget(self, action: #selector(backButtonOnClick), for: .touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOnLogo))
        tapGestureRecognizer.numberOfTapsRequired = 1
        imageContainerView.addGestureRecognizer(tapGestureRecognizer)
        
        
        editProfileButton.layer.cornerRadius = 8
        editProfileButton.layer.borderColor = UIColor.black.cgColor
        editProfileButton.layer.borderWidth = 0.8
        
        detailInfoLabel.text = "Люблю программировать под iOS\nИзучать новые технологии\nЛюблю математику"
        
    }
    
    @objc func backButtonOnClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Logger.log(editProfileButton.frame.debugDescription)
        SetupUI()
    }
    
    fileprivate func getDefaultImagePicker() -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        return imagePicker
    }
    
    fileprivate func checkAccessToCamera() -> Bool {
        if (!UIImagePickerController.isSourceTypeAvailable(.camera)) {
            let noCameraAlert = UIAlertController(title: "Ошибка", message: "Камера не найдена", preferredStyle: .alert)
            
            noCameraAlert.addAction(.okAction)
            
            self.present(noCameraAlert, animated: true)
            return false
        } else if (AVCaptureDevice.authorizationStatus(for: .video) != .authorized) {
            let noAccessAlert = UIAlertController(title: "Беда", message: "Нет доступа к камере, дайте разрешение в настройках", preferredStyle: .alert)
            noAccessAlert.addAction(.okAction)
            self.present(noAccessAlert, animated: true)
            return false
        }
        return true
    }
    
    
    @objc func handleTapOnLogo(_ sender: UITapGestureRecognizer) {
        Logger.log("Выбери изображение профиля")
        
        let pickImageAlertController = UIAlertController(title: "Выберите фото", message: nil, preferredStyle: .actionSheet)
        
        let selectFromGalleryAction = UIAlertAction(title: "Из Галлереи", style: .default) { [weak self] (_) in
            let picker = self?.getDefaultImagePicker()
            picker?.sourceType = UIImagePickerController.SourceType.photoLibrary
            if let picker = picker {
                self?.present(picker, animated: true, completion: nil)
            }
        }
        
        let takePhotoAction = UIAlertAction(title: "Сделать фото", style: .default) { [weak self] (_) in
            
            if (self?.checkAccessToCamera() ?? false) {
            
                let picker = self?.getDefaultImagePicker()
                picker?.sourceType = UIImagePickerController.SourceType.camera
                if let picker = picker {
                    self?.present(picker, animated: true, completion: nil)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (_) in
            pickImageAlertController.dismiss(animated: true, completion: nil)
        }
        
        pickImageAlertController.addAction(selectFromGalleryAction)
        pickImageAlertController.addAction(takePhotoAction)
        pickImageAlertController.addAction(cancelAction)
        
        self.present(pickImageAlertController, animated: true, completion: nil)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.makeCorners()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //Logger.log(detailInfoLabel.frame.debugDescription)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Скорее всего, в viewDidLoad у нас подгружается расположение элементов UI для девайса, который указан в сториборде(то есть их позиции и тд), так как там ViewController еще не добавлен в иерархию view. А уже в viewDidAppear - сработал AutoLayout и расположил их заново и правильно
        Logger.log(editProfileButton.frame.debugDescription)
    }
}

//MARK:UINavigationControllerDelegate
extension ProfileViewController : UINavigationControllerDelegate {
    
}