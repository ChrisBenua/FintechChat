//
//  ConversationViewController.swift
//  FintechChat
//
//  Created by Ирина Улитина on 21/02/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

class ConversationViewController: UIViewController {
    
    private var shouldScrollToLast: Bool! = true
    
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
        ConversationListDataProvider.shared.conversationViewController = self
        self.messages = ConversationListDataProvider.shared.getConversationCellData(name: dialogTitle)
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -70)
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -70)
        self.view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        fillData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        CommunicationManager.shared.communicator.disconnectWithUser(username: dialogTitle)
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
    
    lazy var containerView : UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.init(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1.0)
        container.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
        
        let sepView = UIView()
        sepView.backgroundColor = .lightGray
        container.addSubview(sepView)
        sepView.anchor(top: container.topAnchor, left: container.leftAnchor, bottom: nil, right: container.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.6)
        
        let submitButtn = UIButton(type: .system)
        submitButtn.setTitle("Submit", for: .normal)
        submitButtn.setTitleColor(.black, for: .normal)
        submitButtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButtn.addTarget(self, action: #selector(submitButtonOnClick), for: .touchUpInside)
        
        container.addSubview(messageTextField)
        container.addSubview(submitButtn)
        
        submitButtn.anchor(top: container.topAnchor, left: nil, bottom: container.bottomAnchor, right: container.rightAnchor, paddingTop: 1, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
        messageTextField.anchor(top: container.topAnchor, left: container.leftAnchor, bottom: container.bottomAnchor, right: submitButtn.leftAnchor, paddingTop: 1, paddingLeft: 12, paddingBottom: 10, paddingRight: 12, width: 0, height: 0)
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
            CommunicationManager.shared.communicator.sendMessage(message: text, to: dialogTitle) { (suc, err) in
                
            }
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
            self.tableView.reloadData()
            self.toggleTableView()
        }
       
    }
    
    
}


extension ConversationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
