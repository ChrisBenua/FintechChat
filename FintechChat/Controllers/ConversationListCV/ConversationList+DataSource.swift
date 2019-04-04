//
//  ConversationList+DataSource.swift
//  FintechChat
//
//  Created by Ирина Улитина on 25/02/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UITableViewDataSource
extension ConversationListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in FRC")
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return searchSplittedConversation[section].count
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in FRC")
        }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.cellId, for: indexPath) as? ConversationTableViewCell else { fatalError() }
        let cellData = self.fetchedResultsController.object(at: indexPath)
        let participantUsername = (cellData.participants)?.name ?? "Unrecognized"
        let lastMessage = (cellData.lastMessage)?.text
        let lastMessageDate = (cellData.lastMessage)?.timestamp ?? Date(timeIntervalSince1970: 0)
        let isOnline = cellData.isOnline
        let hasUnreadMessages = !(cellData.lastMessage?.didRead ?? true)
        cell.setup(name: participantUsername, message: lastMessage, date: lastMessageDate, online: isOnline, hasUnreadMessages: hasUnreadMessages)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let dialogName = searchedConversations[indexPath.row].name!
        let viewController = ConversationViewController(conversationListDataProvider: self.viewModel, conversationId: self.fetchedResultsController.object(at: indexPath).conversationId!)
        viewController.dialogTitle = (self.fetchedResultsController.object(at: indexPath).participants)?.name ?? "Undefined"
        //vc.connectedUserID = self.viewModel.getUserIdBy(username: dialogName)
        viewController.connectedUserID = (self.fetchedResultsController.object(at: indexPath).participants)?.userId ?? "Undefined"
        viewController.conversation = self.fetchedResultsController.object(at: indexPath)
        if searchController.isActive {
            self.searchController.dismiss(animated: true) { [weak self] in
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
        } else {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
