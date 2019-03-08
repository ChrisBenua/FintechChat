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
    @IBOutlet weak var detailInfoTextField: UITextView!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    lazy var helperView = UIView()
    var stackViewConstraints: [NSLayoutConstraint] = []
    
    private func styleButton(button: UIButton, cornerRadius: CGFloat = 10 , borderColor: CGColor = UIColor.black.cgColor, borderWidth: CGFloat = 0.8) {
        
        button.layer.cornerRadius = cornerRadius
        button.layer.borderWidth = borderWidth
        button.layer.borderColor = borderColor
    }
    
    lazy var saveGCDButton : UIButton = {
        let button = UIButton()
        styleButton(button: button)
        button.addTarget(self, action: #selector(saveGCDButtonOnClick(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("GCD", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        
        return button
    }()
    
    lazy var saveOperationButton: UIButton = {
        let button = UIButton()
        styleButton(button: button)
        button.addTarget(self, action: #selector(saveOperationButtonOnClick(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Operation", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        
        return button
    }()
    
    lazy var saveButtonsStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [saveGCDButton, helperView, saveOperationButton])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        let firstButtonWidthMultiplier: CGFloat = 0.44
        let secondButtonWidthMultiplier: CGFloat = 0.44
        
        stackViewConstraints = [
            helperView.widthAnchor.constraint(equalTo: sv.widthAnchor, multiplier: 1 - secondButtonWidthMultiplier - firstButtonWidthMultiplier),

            saveGCDButton.widthAnchor.constraint(equalTo: sv.widthAnchor, multiplier: firstButtonWidthMultiplier),
            saveOperationButton.widthAnchor.constraint(equalTo: sv.widthAnchor, multiplier: secondButtonWidthMultiplier)
            ]
        //NSLayoutConstraint.activate(stackViewConstraints)
        return sv
    }()
    
    
    
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
        
        
        styleButton(button: editProfileButton)
        editProfileButton.addTarget(self, action: #selector(editButtonOnClick), for: .touchUpInside)
        
        //detailInfoTextField.text = "Люблю программировать под iOS\nИзучать новые технологии\nЛюблю математику"
        nameTextField.isUserInteractionEnabled = false
    }
    
    @objc func backButtonOnClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Logger.log(editProfileButton.frame.debugDescription)
        SetupUI()
        self.UpdateUI()
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
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { [weak pickImageAlertController] (_) in
            pickImageAlertController?.dismiss(animated: true, completion: nil)
        }
        
        pickImageAlertController.addAction(selectFromGalleryAction)
        pickImageAlertController.addAction(takePhotoAction)
        pickImageAlertController.addAction(cancelAction)
        
        self.present(pickImageAlertController, animated: true, completion: nil)
        
    }
    
    @objc func editButtonOnClick(_ sender : Any) {
        self.nameTextField.isUserInteractionEnabled = true
        self.detailInfoTextField.isUserInteractionEnabled = true
        self.detailInfoTextField.isEditable = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.editProfileButton.alpha = 0
        }) { (_) in
            self.editProfileButton.isUserInteractionEnabled = false
            self.view.addSubview(self.saveButtonsStackView)
            self.saveButtonsStackView.anchor(top: nil, left: self.view.leftAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, width: 0, height: 0)
            self.stackViewConstraints.append(self.saveButtonsStackView.heightAnchor.constraint(greaterThanOrEqualTo: self.view.heightAnchor, multiplier: 0.06))
            NSLayoutConstraint.activate(self.stackViewConstraints)
        }
    }
    
    @objc func saveGCDButtonOnClick(_ sender : Any?) {
        self.saveGCDButton.isEnabled = false
        self.saveOperationButton.isEnabled = false
        
        GCDDataManager.shared.saveUserProfileInfo(profileImage: profilePhotoImageView.image, username: nameTextField.text, userDetailInfo: detailInfoTextField.text, onComplete: { [weak self] in
            if (self != nil) {
                self!.UpdateUI(showAlert: true)
            }
        }) { [weak self] in
            if (self != nil) {
                DispatchQueue.main.async {
                    self!.present((self!.generateAlertController(retryFunc: (self!.saveGCDButtonOnClick(_:)))), animated: true, completion: nil)
                    self!.saveGCDButton.isEnabled = true
                    self!.saveOperationButton.isEnabled = true
                }
                
            }
        }
    }
    
    @objc func saveOperationButtonOnClick(_ sender : Any?) {
        
    }
    
    private func UpdateUI(showAlert: Bool = false) {
        GCDDataManager.shared.getUserProfileInfo(onComplete: { [weak self] (detailInfo, username, profileImage) in
            self?.UpdateUIAfterFetch(detailInfo: detailInfo, username: username, profileImage: profileImage, showAlert: showAlert)
        })
    }
    
    private func UpdateUIAfterFetch(detailInfo: String?, username: String?, profileImage: UIImage?, showAlert: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            self?.detailInfoTextField.text = detailInfo
            self?.nameTextField.text = username
            self?.profilePhotoImageView.image = profileImage ?? self?.profilePhotoImageView.image
            
            if (showAlert) {
                self?.present(UIAlertController.okAlertController(title: "Saved Succesfully"), animated: true, completion: nil)
            }
            
            self?.saveGCDButton.isEnabled = true
            self?.saveOperationButton.isEnabled = true
        }
    }
    
    private func generateAlertController(retryFunc: @escaping (Any?) -> ()?) -> UIAlertController {
        let alertController = UIAlertController(title: "Error", message: "Can't save to file", preferredStyle: .alert)
        let okAction = UIAlertAction.okAction
        
        let retryAction = UIAlertAction(title: "Retry", style: .default) { (_) in
            retryFunc(nil)
        }
        alertController.addAction(okAction)
        alertController.addAction(retryAction)
        
        return alertController
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
