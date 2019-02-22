//
//  ConversationListViewController.swift
//  FintechChat
//
//  Created by Ирина Улитина on 21/02/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

class ConversationListViewController : UIViewController {
    private let rowHeight: CGFloat = 80
    
    private var sectionNames: [String] = ["Online", "History"]
    
    private var allConversations: [ConversationCellConfiguration] = [ConversationCellConfiguration]()
    
    private var splittedConversations: [[ConversationCellConfiguration]] = [[ConversationCellConfiguration]]()
    
    private func fillSplittedConversations() {
        let activeConversations = allConversations.filter({ $0.online })
        let inactiveConversations = allConversations.filter({ !$0.online })
        splittedConversations.removeAll()
        splittedConversations.append(activeConversations)
        splittedConversations.append(inactiveConversations)
    }
    
    private func fillWithData() {
        let names = ["Matthew McConaughey", "Anne Hathaway", "Jessica Chastain", "Mackenzie Foy", "Ellen Burstyn", "Matt Damon", "John Lithgow", "Michael Caine", "Casey Affleck", "Timothée Chalamet", "Wes Bentley", "Bill Irwin", "Josh Stewart", "Topher Grace", "David Gyasi", "Leah Cairns", "David Oyelowo", "Collette Wolfe", "William Devane", "Elyes Gabel "]
        let lastMessage = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna"
        
        for i in 0..<names.count {
            let message: String? = i % 5 == 0 ? nil : lastMessage
            let date: Date = i % 7 == 0 ? Date(timeIntervalSince1970: 1194779471) : Date()
            let model = ConversationCellModelHelper(name: names[i], message: message , date: date, online: i < 10, hasUnreadMessages: i % 3 == 0)
            allConversations.append(model)
        }
        fillSplittedConversations()
    }
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        
        tv.register(ConversationTableViewCell.self, forCellReuseIdentifier: ConversationTableViewCell.cellId)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Tinkoff Chat"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "user").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(profileButtonOnClick))
        
        self.view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        self.fillWithData()
        self.tableView.reloadData()
    }
    
    @objc func profileButtonOnClick(_ sender: Any) {
        let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC")
        self.present(profileVC, animated: true, completion: nil)
    }
    
}

//MARK:- UITableViewDelegate
extension ConversationListViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }
}

//MARK:- UITableViewDataSource
extension ConversationListViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return splittedConversations[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.cellId, for: indexPath) as! ConversationTableViewCell
        let cellData = splittedConversations[indexPath.section][indexPath.row]
        cell.setup(name: cellData.name, message: cellData.message, date: cellData.date, online: cellData.online, hasUnreadMessages: cellData.hasUnreadMessages)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dialogName = splittedConversations[indexPath.section][indexPath.row].name
        let vc = ConversationViewController()
        vc.dialogTitle = dialogName
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
