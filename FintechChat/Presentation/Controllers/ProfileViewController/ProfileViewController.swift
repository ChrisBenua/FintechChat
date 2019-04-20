//
//  ViewController.swift
//  FintechChat
//
//  Created by Ирина Улитина on 07/02/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import UIKit
import AVFoundation

protocol IProfileViewController: UIViewController, IProfileViewControllerSetImageDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var editingAdapter: IEditingAdapter { get set }
    var profileModel: IProfileModel! { get set }
}
    

class ProfileViewController: UIViewController, IProfileViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var detailInfoTextField: TextViewWithDoneButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    var logoService: ITinkoffLogosService = TinkoffLogosService()
    lazy var helperView = UIView()
    var stackViewConstraints: [NSLayoutConstraint] = []
    var tapGestureRecognizer: UITapGestureRecognizer!
    var lastState: UserProfileState!
    var lastFirstResponderFrame: CGRect?
    public static let maxNameLen = 33
    
    var editingAdapter: IEditingAdapter = EditingAdapter()
    
    var profileModel: IProfileModel!
    
    var assembly: IPresentationAssembly!

    private func styleButton(button: UIButton, cornerRadius: CGFloat = 10, borderColor: CGColor = UIColor.black.cgColor, borderWidth: CGFloat = 0.8) {
        
        button.layer.cornerRadius = cornerRadius
        button.layer.borderWidth = borderWidth
        button.layer.borderColor = borderColor
    }
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        styleButton(button: button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .disabled)
        button.isEnabled = false
        button.addTarget(self, action: #selector(saveButtonOnClick(_:)), for: .touchUpInside)
        button.isHidden = true
        
        return button
    }()
    
    
    lazy var savingProcessView: ISavingProcessView = SavingProcessView()
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("Not implemented init from coder")
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
    
    fileprivate func setupUI() {
        backButton.addTarget(self, action: #selector(backButtonOnClick), for: .touchUpInside)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOnLogo))
        tapGestureRecognizer.isEnabled = false

        tapGestureRecognizer.numberOfTapsRequired = 1
        imageContainerView.addGestureRecognizer(tapGestureRecognizer)
        
        
        styleButton(button: editProfileButton)
        editProfileButton.addTarget(self, action: #selector(editButtonOnClick), for: .touchUpInside)
        
        nameTextField.isUserInteractionEnabled = false
    }
    
    fileprivate func placeEditingButtons() {
        self.view.addSubview(self.saveButton)
        
        self.saveButton.anchor(top: nil, left: self.view.leftAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, width: 0, height: 0)
        self.saveButton.heightAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.06).isActive = true
        
    }
    
    fileprivate func setupTextChangedHandlers() {
        detailInfoTextField.delegate = self
        nameTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
    }
    
    @objc func backButtonOnClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func fetchProfileInfoCoreData() {
        self.profileModel.getUserProfileState(from: nil, completion: { profileState in
            self.updateUIAfterFetch(state: profileState)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Logger.log(editProfileButton.frame.debugDescription)
        self.setupUI()
        
        self.editingAdapter.addButtons(defaultButtons: [editProfileButton], invertedButtons: [saveButton])
        self.editingAdapter.addGestures(defaultGestures: [self.tapGestureRecognizer], invertedGestures: [])
        self.editingAdapter.addTextFields(defaultsTextFields: [self.nameTextField, self.detailInfoTextField], invertedTextFields: [])
        //self.FetchProfileInfo(shared: GCDDataManager.shared)
        self.fetchProfileInfoCoreData()
        self.setupTextChangedHandlers()
        self.placeEditingButtons()
        self.addObservers(showSelector: #selector(onShowKeyboard(notification:)), hideSelector: #selector(onHideKeyboards(notification:)))
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mainViewOnTap)))
        self.addTinkoffTapListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeObservers()
    }
    
    @objc func mainViewOnTap(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @objc func handleTapOnLogo(_ sender: UITapGestureRecognizer) {
        Logger.log("Выбери изображение профиля")
        self.present(self.profileModel.logoAlertController(sourceView: self), animated: true)
    }
    
    @objc func editButtonOnClick(_ sender: Any) {
        self.changeEditingMode(true)
    }
    
    @objc func saveButtonOnClick(_ sender: Any?) {
        showSavingProccessView()
        //self.toggleEditingButtons(false)
        self.editingAdapter.toggleEditing(isEditing: false)
        
        self.profileModel.saveUserProfileState(profileState: self.constructUserProfileInfo(), completion: { [weak self] in
            self?.profileModel.getUserProfileState(from: nil, completion: { profileState in
                DispatchQueue.main.async {
                    self?.updateUIAfterFetch(state: profileState, showAlert: true)
                    self?.profileModel.communicator.communicator.reinitAdvertiser(newUserName: self!.nameTextField.text!)
                }
            })
        }, in: nil)
    }
    
    private func fetchProfileInfo(showAlert: Bool = false, shared: UserProfileDataDriver) {
        shared.getUserProfileInfo(onComplete: { [weak self] (state) in
            self?.updateUIAfterFetch(state: state, showAlert: showAlert)
        })
    }
    
    private func updateUIAfterFetch(state: UserProfileState, showAlert: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            self?.dismissSavingProcessView()
            self?.detailInfoTextField.text = state.detailInfo ?? self?.detailInfoTextField.text
            self?.nameTextField.text = state.username ?? self?.nameTextField.text
            self?.profilePhotoImageView.image = state.profileImage ?? self?.profilePhotoImageView.image
            
            if showAlert {
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
    
    private func constructUserProfileInfo() -> UserProfileState {
        return UserProfileState(username: nameTextField.text, profileImage: profilePhotoImageView.image, detailInfo: detailInfoTextField.text)
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
        //Скорее всего, в viewDidLoad у нас подгружается расположение элементов UI для девайса, который указан в сториборде
        //(то есть их позиции и тд), так как там ViewController еще не добавлен в иерархию view. А уже в viewDidAppear - сработал AutoLayout и расположил их заново и правильно
        Logger.log(editProfileButton.frame.debugDescription)
    }
}

// MARK: - Factory
extension ProfileViewController {
    class func `init`(profileModel: IProfileModel, assembly: IPresentationAssembly) -> ProfileViewController {
        let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as? ProfileViewController
        profileVC?.profileModel = profileModel
        profileVC?.assembly = assembly
        return profileVC!
    }
}

extension ProfileViewController: IProfileViewControllerSetImageDelegate {
    func onShowPreviewImage(image: UIImage?) {
        self.profilePhotoImageView.image = image
    }
    
    func onShowFullImage(image: UIImage?) {
        self.profilePhotoImageView.image = image
        self.editingAdapter.toggleEditingButtons(isEditing: true)
    }
    
    
}

// MARK: ActivityIndicator
extension ProfileViewController {
    func showSavingProccessView() {
        self.savingProcessView.showSavingProcessView(sourceView: self)
    }
    
    func dismissSavingProcessView() {
        self.savingProcessView.dismissSavingProcessView()
    }
}

// MARK: EditingButtons
/*
 invButtons: saveButton
 defaultButton: editButton
 defClosures: toggleEditing
 defGesture: tapGestureREcongzer
 */
extension ProfileViewController {
    func changeEditingMode(_ isEditing: Bool) {
        if isEditing {
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.editProfileButton.alpha = 0
            }, completion: { [weak self] (_) in
                
                self?.editingAdapter.toggleEditing(isEditing: true)
                
                UIView.animate(withDuration: 0.5, animations: { [weak self] in
                    self?.saveButton.alpha = 1
                    }, completion: nil)
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.saveButton.alpha = 0
            }, completion: { [weak self] (_) in
                
                self?.editingAdapter.toggleEditing(isEditing: false)
                
                UIView.animate(withDuration: 0.5) { [weak self] in
                    self?.editProfileButton.alpha = 1
                }
                self?.saveButton.isEnabled = false
                //self?.editingAdapter.toggleEditingInputFields(isEditing: false)
            })
            
        }
    }
}

// MARK: - Moving Keyboards
extension ProfileViewController {
    
    @objc func onShowKeyboard(notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height {
            if self.view.frame.origin.y == 0 {
                if let lastFrame = lastFirstResponderFrame {
                    let lastFrameBottomY = lastFrame.origin.y + lastFrame.height
                    let currentTopKeyboardY = self.view.frame.height - keyboardHeight
                    UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
                        
                        Logger.log((lastFrameBottomY - currentTopKeyboardY).description)
                        
                        if lastFrameBottomY > currentTopKeyboardY {
                            self.view.frame.origin.y -= (lastFrameBottomY - currentTopKeyboardY)
                        }
                        
                    }, completion: nil)
                }
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

// MARK: - TextFieldTextChanged
extension ProfileViewController {
    @objc func textDidChanged(_ textField: UITextField) {
        if textField.text!.count > ProfileViewController.maxNameLen {
            textField.text = String(textField.text!.prefix(ProfileViewController.maxNameLen))
        }
        self.editingAdapter.toggleEditingButtons(isEditing: true)
        //self.toggleEditingButtons(true)
    }
}

extension ProfileViewController: ITinkoffLogosController {
    func addTinkoffTapListener() {
        logoService.setup(view: self.view, time: 0.2)
    }
    
    
}

// MARK: - UINavigationControllerDelegate
extension ProfileViewController: UINavigationControllerDelegate {
}
