//
//  AccessoryView.swift
//  FintechChat
//
//  Created by Ирина Улитина on 09/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation

protocol IConversationAccessoryView: UIView {
    func setup(communicator: ICommunicationManager, connectedUserID: String, target: Any?, selector: Selector, event: UIControl.Event)
    
    func setTextFieldDelegate(delegate: UITextFieldDelegate)
    
    func currentText() -> String?
    
    func afterSend()
    
    
    func toggleEditingButton(_ isEnabled: Bool)
    
    var isConnected: Bool { get set }
    //var submitButton: UIButton { get }
}

class ConversationAccessoryView: UIView, IConversationAccessoryView {
    
    var isConnected: Bool = false
    
    func toggleEditingButton(_ isEnabled: Bool) {
        //self.submitButton.isEnabled = isEnabled
        self.isConnected = isEnabled
        animateButton()
    }
    
    func animateButton() {
        if (isConnected && (self.messageTextField.text?.count ?? 0) > 0) && !self.submitButton.isEnabled {
            UIView.animate(withDuration: 0.5, animations: {
                self.submitButton.isEnabled = true
                self.submitButton.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            }, completion: { (_) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.submitButton.transform = .identity
                }, completion: nil)
            })
        } else if self.submitButton.isEnabled && (!isConnected || (self.messageTextField.text?.count ?? 0) == 0) {
            UIView.animate(withDuration: 0.5, animations: {
                self.submitButton.isEnabled = false
                self.submitButton.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            }, completion: { (_) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.submitButton.transform = .identity
                }, completion: nil)
            })
        }
    }
    
    func afterSend() {
        self.messageTextField.text = ""
        self.animateButton()
    }
    
    func currentText() -> String? {
        return self.messageTextField.text
    }
    
    
    let accessoryViewHeight: CGFloat = 65
    
    lazy var messageTextField: UITextField = {
        let tfield = UITextField()
        tfield.placeholder = "   Enter comment"
        
        tfield.backgroundColor = .white
        tfield.layer.cornerRadius = 5
        tfield.layer.borderWidth = 0.5
        tfield.layer.borderColor = UIColor.white.cgColor
        //tfield.delegate = self
        return tfield
    }()
    
    func setTextFieldDelegate(delegate: UITextFieldDelegate) {
        self.messageTextField.delegate = delegate
    }
    
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.isEnabled = false
        //button.addTarget(self, action: #selector(submitButtonOnClick), for: .touchUpInside)
        //button.isEnabled = false
        
        /*let state = self.communicator.communicator.lastState[self.connectedUserID]
        Logger.log("IN BUTTON INIT " + (state?.myDebug() ?? "NIL NOW") + " with " + self.connectedUserID)
        
        if self.communicator.communicator.lastState[self.connectedUserID] != .connected {
            button.isEnabled = false
        }*/
        
        return button
    }()
    
    func setup(communicator: ICommunicationManager, connectedUserID: String, target: Any?, selector: Selector, event: UIControl.Event) {
        self.submitButton.addTarget(target, action: selector, for: event)
        let state = communicator.communicator.lastState[connectedUserID]
        if state != .connected {
            self.isConnected = false
        } else {
            self.isConnected = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1.0)
        self.frame = CGRect(x: 0, y: 0, width: 100, height: self.accessoryViewHeight)
        
        let sepView = UIView()
        sepView.backgroundColor = .lightGray
        self.addSubview(sepView)
        sepView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.6)
        
        
        
        self.addSubview(messageTextField)
        self.addSubview(submitButton)
        
        submitButton.anchor(top: self.topAnchor, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 1, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 55, height: 0)
        messageTextField.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 1, paddingLeft: 12, paddingBottom: 10, paddingRight: 4, width: 0, height: 0)
        self.messageTextField.addTarget(self, action: #selector(onMessageTextFieldEvents), for: .allEditingEvents)
    }
    
    @objc func onMessageTextFieldEvents() {
        self.animateButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
