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
    var tapGestureRecognizer: UITapGestureRecognizer!
    var lastState: UserProfileState!
    var lastFirstResponderFrame: CGRect?
    
    
    let savingLabel: UILabel = {
        let label = UILabel()
        label.text = "Saving..."
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
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
        button.setTitleColor(UIColor.lightGray, for: .disabled)
        button.isEnabled = false

        return button
    }()
    
    lazy var saveOperationButton: UIButton = {
        let button = UIButton()
        styleButton(button: button)
        button.addTarget(self, action: #selector(saveOperationButtonOnClick(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Operation", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .disabled)

        button.isEnabled = false
        
        return button
    }()
    
    lazy var activityIndicator = UIActivityIndicatorView(style: .gray)
    
    lazy var savingProcessView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.alpha = 0.7
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.addSubview(activityIndicator)
        view.addSubview(savingLabel)

        
        savingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        savingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
        
        //label.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
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
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOnLogo))
        tapGestureRecognizer.isEnabled = false

        tapGestureRecognizer.numberOfTapsRequired = 1
        imageContainerView.addGestureRecognizer(tapGestureRecognizer)
        
        
        styleButton(button: editProfileButton)
        editProfileButton.addTarget(self, action: #selector(editButtonOnClick), for: .touchUpInside)
        
        //detailInfoTextField.text = "Люблю программировать под iOS\nИзучать новые технологии\nЛюблю математику"
        nameTextField.isUserInteractionEnabled = false
        
    }
    
    fileprivate func placeEditingButtons() {
        self.view.addSubview(self.saveButtonsStackView)
        self.saveButtonsStackView.isHidden = true
        
        self.saveButtonsStackView.anchor(top: nil, left: self.view.leftAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, width: 0, height: 0)
        self.stackViewConstraints.append(self.saveButtonsStackView.heightAnchor.constraint(greaterThanOrEqualTo: self.view.heightAnchor, multiplier: 0.06))
        NSLayoutConstraint.activate(self.stackViewConstraints)
    }
    
    fileprivate func SetupTextChangedHandlers() {
        detailInfoTextField.delegate = self
        nameTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
    }
    
    @objc func backButtonOnClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Logger.log(editProfileButton.frame.debugDescription)
        self.SetupUI()
        self.FetchProfileInfo(shared: GCDDataManager.shared)
        self.SetupTextChangedHandlers()
        self.placeEditingButtons()
        self.addObservers()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mainViewOnTap)))
    }
    
    @objc func mainViewOnTap(_ sender: Any) {
        self.view.endEditing(true)
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
        
        /*UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.editProfileButton.alpha = 0
        }) { (_) in
            self.editProfileButton.isUserInteractionEnabled = false
//            self.view.addSubview(self.saveButtonsStackView)
//            self.saveButtonsStackView.alpha = 0
//            self.saveButtonsStackView.anchor(top: nil, left: self.view.leftAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, width: 0, height: 0)
//            self.stackViewConstraints.append(self.saveButtonsStackView.heightAnchor.constraint(greaterThanOrEqualTo: self.view.heightAnchor, multiplier: 0.06))
//            NSLayoutConstraint.activate(self.stackViewConstraints)
            
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.saveButtonsStackView.alpha = 1
            })
        }*/
        
        self.changeEditingMode(true)
        
    }
    
    @objc func saveGCDButtonOnClick(_ sender : Any?) {
        showSavingProccessView()
        self.toggleEditingButtons(false)
        
        GCDDataManager.shared.saveUserProfileInfo(state: profileStateWithoutSameFieldsInProfile(), onComplete: { [weak self] in
            if (self != nil) {
                self!.FetchProfileInfo(showAlert: true, shared: GCDDataManager.shared)
            }
        }) { [weak self] in
            if (self != nil) {
                DispatchQueue.main.async {
                    self!.present((self!.generateAlertController(retryFunc: (self!.saveGCDButtonOnClick(_:)))), animated: true, completion: nil)
                    self?.toggleEditingButtons(true)
                }
                
            }
        }
    }
    
    @objc func saveOperationButtonOnClick(_ sender : Any?) {
        showSavingProccessView()
        self.toggleEditingButtons(false)
        
        OperationDataManager.shared.saveUserProfileInfo(state: profileStateWithoutSameFieldsInProfile(), onComplete: { [weak self] in
            if (self != nil) {
                self!.FetchProfileInfo(showAlert: true, shared: OperationDataManager.shared)
            }
        }) { [weak self] in
            if (self != nil) {
                DispatchQueue.main.async {
                    self!.present(self!.generateAlertController(retryFunc: self!.saveOperationButtonOnClick(_:)), animated: true, completion: nil)
                    
                    self?.toggleEditingButtons(true)
                }
            }
        }
    }
    
    private func profileStateWithoutSameFieldsInProfile() -> UserProfileState {
        var currentUserProfileInfo = constructUserProfileInfo()
        
        if (currentUserProfileInfo.detailInfo == lastState.detailInfo) {
            currentUserProfileInfo.detailInfo = nil
        }
        
        if (currentUserProfileInfo.username == lastState.username) {
            currentUserProfileInfo.username = nil
        }
        
        if (currentUserProfileInfo.profileImage == lastState.profileImage) {
            currentUserProfileInfo.profileImage = nil
        }
        
        return currentUserProfileInfo
    }
    
    private func FetchProfileInfo(showAlert: Bool = false, shared: UserProfileDataDriver) {
        shared.getUserProfileInfo(onComplete: { [weak self] (state) in
            self?.UpdateUIAfterFetch(state: state, showAlert: showAlert)
        })
    }
    
    private func UpdateUIAfterFetch(state: UserProfileState, showAlert: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            self?.dismissSavingProcessView()
            self?.detailInfoTextField.text = state.detailInfo ?? self?.detailInfoTextField.text
            self?.nameTextField.text = state.username ?? self?.nameTextField.text
            self?.profilePhotoImageView.image = state.profileImage ?? self?.profilePhotoImageView.image
            
            if (showAlert) {
                self?.present(UIAlertController.okAlertController(title: "Saved Succesfully"), animated: true, completion: nil)
                //self?.toggleEditing(true)
                self?.tapGestureRecognizer.isEnabled = true
                self?.changeEditingMode(false)
            } else {
                //можно, так как UserProfileState - структура
                self?.lastState = state
            }
            
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
    
    private func constructUserProfileInfo() -> UserProfileState {
        return UserProfileState(username: nameTextField.text, profileImage: profilePhotoImageView.image, detailInfo: detailInfoTextField.text)
    }
    
    func toggleEditingButtons(_ enable: Bool) {
        self.tapGestureRecognizer.isEnabled = enable
        self.saveGCDButton.isEnabled = enable
        self.saveOperationButton.isEnabled = enable
    }
    
    private func toggleEditingInputFields(_ enable: Bool) {
        self.nameTextField.isUserInteractionEnabled = enable
        self.detailInfoTextField.isUserInteractionEnabled = enable
        self.detailInfoTextField.isEditable = enable
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

//MARK: ActivityIndicator
extension ProfileViewController {
    func showSavingProccessView() {
        self.view.addSubview(self.savingProcessView)
        self.activityIndicator.startAnimating()
        savingProcessView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        savingProcessView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        savingProcessView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.13).isActive = true
        savingProcessView.widthAnchor.constraint(equalTo: self.savingProcessView.heightAnchor, multiplier: 1).isActive = true

    }
    
    func dismissSavingProcessView() {
        self.activityIndicator.stopAnimating()
        self.savingProcessView.removeFromSuperview()
    }
}

//MARK: EditingButtons
extension ProfileViewController {
    func changeEditingMode(_ isEditing: Bool) {
        if isEditing {
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.editProfileButton.alpha = 0
            }) { [weak self] (_) in
                self?.saveButtonsStackView.isHidden = false
                self?.editProfileButton.isHidden = true
                self?.toggleEditingInputFields(true)
                self?.tapGestureRecognizer.isEnabled = true

                
                UIView.animate(withDuration: 0.5, animations: { [weak self] in
                    self?.saveButtonsStackView.alpha = 1
                    }, completion: nil)
            }
            
            
            
        } else {
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.saveButtonsStackView.alpha = 0
            }) { [weak self] (_) in
                self?.saveButtonsStackView.isHidden = true
                self?.editProfileButton.isHidden = false
                self?.tapGestureRecognizer.isEnabled = false
                
                UIView.animate(withDuration: 0.5) { [weak self] in
                    self?.editProfileButton.alpha = 1
                }
                self?.toggleEditingInputFields(false)
            }
            
        }
    }
}

//MARK:- Moving Keyboards

extension ProfileViewController {
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(onShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onHideKeyboards), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func onShowKeyboard(notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height {
            if self.view.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                    if let lastFrame = self.lastFirstResponderFrame {
                        Logger.log("lastFrame")
                        Logger.log((lastFrame.origin.y + lastFrame.height).description)
                        Logger.log("view.height - keyboardHeight")
                        Logger.log((self.view.frame.height - keyboardHeight).description)
                        if (lastFrame.origin.y + lastFrame.height > self.view.frame.origin.y + self.view.frame.height - keyboardHeight) {
                            self.view.frame.origin.y = -(lastFrame.origin.y + lastFrame.height - (self.view.frame.origin.y + self.view.frame.height - keyboardHeight))
                        }
                    }
                }, completion: nil)
            }
        }
    }
    
    @objc func onHideKeyboards(notification: NSNotification) {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.frame.origin.y = 0
        }, completion: { (_) in
            Logger.log("After set to default origin:" + self.view.frame.origin.y.description)
            Logger.log(self.view.frame.debugDescription)
        })
    }
}

//MARK:- TextFieldTextChanged
extension ProfileViewController {
    @objc func textDidChanged(_ textField: UITextField) {
        self.toggleEditingButtons(true)
    }
}

//MARK:- UINavigationControllerDelegate
extension ProfileViewController : UINavigationControllerDelegate {
    
}
