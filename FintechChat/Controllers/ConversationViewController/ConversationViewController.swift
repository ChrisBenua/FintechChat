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
        for i in 0..<10 {
            let model = ConversationMessageModelHelper(messageText: String(repeating: "w", count: 5 + 15 * i), isIncoming: i % 2 == 0)
            messages.append(model)
        }
        
        tableView.reloadData()
    }
    
    var dialogTitle: String! {
        didSet {
            self.navigationItem.title = dialogTitle
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
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        fillData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (!messages.isEmpty && shouldScrollToLast) {
            shouldScrollToLast = false
            tableView.setContentOffset(CGPoint(x: 0, y: max(tableView.contentSize.height - tableView.frame.height, 0)), animated: true)
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
