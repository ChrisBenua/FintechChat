//
//  ConversationViewController.swift
//  FintechChat
//
//  Created by Ирина Улитина on 21/02/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class ConversationViewController: UIViewController {
    
    private var shouldScrollToLast: Bool! = true
    
    private var didLeaveDialog: Bool = false
    
    private let accessoryViewHeight: CGFloat = 65
    
    private func markMessagesAsRead() {
        for el in ConversationListDataProvider.shared.messageStorage[dialogTitle]! {
            el.didRead = true
        }
    }
    
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        if (parent == nil) {
            didLeaveDialog = true
        }

    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            if indexPath.row >= 0 {
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                Logger.log("SCROLL")
            }
        }
    }
    
    private func fillData() {
        /*for i in 0..<10 {
            let model = ConversationMessageModelHelper(messageText: String(repeating: "w", count: 5 + 15 * i), isIncoming: i % 2 == 0)
            messages.append(model)
        }
        tableView.reloadData()*/
    }
    
    var dialogTitle: String! {
        didSet {
            self.navigationItem.title = dialogTitle
            CommunicationManager.shared.communicator.connectWithUser(username: dialogTitle)
        }
    }
    
    private var messages = [MessageCellExtendedConfiguration]()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.delegate = self
        tv.dataSource = self
        tv.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.cellId)
        return tv
    }()
    
    override func viewDidLoad() {
        //CommunicationManager.shared.communicator.advertiser.stopAdvertisingPeer()
        self.addObservers()
        CommunicationManager.shared.communicator.onDisconnectDelegate = self
        ConversationListDataProvider.shared.conversationViewController = self
        self.messages = ConversationListDataProvider.shared.getConversationCellData(name: dialogTitle)
        super.viewDidLoad()
        
        self.markMessagesAsRead()
        
        //self.navigationItem.backBarButtonItem?.action = #selector(customBackButtonOnClick(_:))
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -70)
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -70)
        self.view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        fillData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeObservers()
        super.viewWillDisappear(animated)
        
        CommunicationManager.shared.communicator.disconnectWithUser(username: dialogTitle)
        //CommunicationManager.shared.communicator.advertiser.startAdvertisingPeer()

    }
    
    private func toggleTableView() {
        /*if (tableView.contentSize.height < self.view.frame.height) {
            Logger.log(tableView.contentSize.height.description)
            Logger.log("\(tableView.contentSize.height - self.view.frame.height)")
            UIView.animate(withDuration: 0.2) {
                self.tableView.contentInset = UIEdgeInsets(top: self.view.frame.height - self.tableView.contentSize.height, left: 0, bottom: 0, right: 0)
            }
            
        }*/
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        toggleTableView()
       
        
        /*if (!messages.isEmpty && shouldScrollToLast && tableView.contentSize.height >= self.view.frame.height) {
            shouldScrollToLast = false
            tableView.setContentOffset(CGPoint(x: 0, y: max(tableView.contentSize.height - tableView.frame.height, 0)), animated: true)
        }*/
    }
    
    lazy var messageTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "   Enter comment"
        
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 5
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.white.cgColor
        tf.delegate = self
        return tf
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(submitButtonOnClick), for: .touchUpInside)
        
        if CommunicationManager.shared.communicator.lastState != .connected {
            button.isEnabled = false
        }
        
        return button
    }()
    
    lazy var containerView : UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.init(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1.0)
        container.frame = CGRect(x: 0, y: 0, width: 100, height: self.accessoryViewHeight)
        
        let sepView = UIView()
        sepView.backgroundColor = .lightGray
        container.addSubview(sepView)
        sepView.anchor(top: container.topAnchor, left: container.leftAnchor, bottom: nil, right: container.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.6)
        
        
        
        container.addSubview(messageTextField)
        container.addSubview(submitButton)
        
        submitButton.anchor(top: container.topAnchor, left: nil, bottom: container.bottomAnchor, right: container.rightAnchor, paddingTop: 1, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 55, height: 0)
        messageTextField.anchor(top: container.topAnchor, left: container.leftAnchor, bottom: container.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 1, paddingLeft: 12, paddingBottom: 10, paddingRight: 4, width: 0, height: 0)
        return container
        
    }()
    
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc func submitButtonOnClick() {
        let text = messageTextField.text!
        if (text.count != 0) {
            CommunicationManager.shared.communicator.sendMessage(message: text, to: dialogTitle) { [weak self] (suc, err) in
                
                if (!suc) {
                    let alertController = UIAlertController(title: "Error", message: err?.localizedDescription, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction.okAction)
                    
                    DispatchQueue.main.async {
                        self?.present(alertController, animated: true, completion: nil)
                    }
                }
            }
            
            messageTextField.text = ""
        }
    }
    
}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.cellId, for: indexPath) as! MessageTableViewCell
        
        cell.setup(messageText: messages[indexPath.row].messageText, isIncoming: messages[indexPath.row].isIncoming)
        return cell
    }
    
}

extension ConversationViewController: UITableViewDelegate {
    
}

extension ConversationViewController: UpdateConversationControllerDelegate {
    func updateConversation() {
        self.messages = ConversationListDataProvider.shared.getConversationCellData(name: dialogTitle)
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            if (indexPath.row >= 0) {
                self.tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            }
            //self.toggleTableView()
            self.markMessagesAsRead()
            self.scrollToBottom()
        }
       
    }
    
    
}


extension ConversationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


protocol OnUserDisconnectedDelegate: class {
    func userDidDisconnected(state: MCSessionState)
}

extension ConversationViewController: OnUserDisconnectedDelegate {
    func userDidDisconnected(state: MCSessionState) {
        DispatchQueue.main.async { [weak self] in
            
            if (self != nil && !self!.didLeaveDialog) {
                
                if (state == .notConnected) {
                    self!.submitButton.isEnabled = false
                    let alertController = UIAlertController(title: "Alert", message: "This peer disconnected from you", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction.okAction)
                    alertController.addAction(UIAlertAction(title: "Leave dialog", style: .destructive, handler: { [weak self] (_) in
                        self!.navigationController?.popViewController(animated: true)
                    }))
                    self!.present(alertController, animated: true, completion: nil)
                } else if (state == .connected) {
                    self!.submitButton.isEnabled = true
                }
            }
        }
        
    }
}

//MARK:- Keyboard
extension ConversationViewController {
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(onShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func onShowKeyboard(notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -keyboardHeight + 10, right: 0)
                    self?.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - 10, right: 0)
                }
            })
            { [weak self] (_) in
                self?.scrollToBottom()
            }
            
        }
    }
    
    @objc func onHideKeyboard() {
        UIView.animate(withDuration: 0.5, animations: {
            DispatchQueue.main.async { [weak self] in
                if (self != nil) {
                    self!.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -self!.accessoryViewHeight, right: 0)
                    self!.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -self!.accessoryViewHeight, right: 0)
                }
            }
        }) { [weak self] (_) in
            self?.scrollToBottom()

        }

    }
}
