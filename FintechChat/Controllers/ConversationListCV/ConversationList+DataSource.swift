//
//  ConversationList+DataSource.swift
//  FintechChat
//
//  Created by Ирина Улитина on 25/02/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

//MARK:- UITableViewDataSource
extension ConversationListViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchSplittedConversation[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.cellId, for: indexPath) as! ConversationTableViewCell
        let cellData = searchSplittedConversation[indexPath.section][indexPath.row]
        cell.setup(name: cellData.name, message: cellData.message, date: cellData.date, online: cellData.online, hasUnreadMessages: cellData.hasUnreadMessages)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dialogName = allSplittedConversations[indexPath.section][indexPath.row].name
        let vc = ConversationViewController()
        vc.dialogTitle = dialogName
        self.searchController.isActive = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
