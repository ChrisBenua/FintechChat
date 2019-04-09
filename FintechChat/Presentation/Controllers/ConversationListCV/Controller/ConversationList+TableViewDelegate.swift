//
//  ConversationList+TableViewDelegate.swift
//  FintechChat
//
//  Created by Ирина Улитина on 25/02/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit


// MARK: - UITableViewDelegate
extension ConversationListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let dialogName = searchedConversations[indexPath.row].name!
        //let viewController = ConversationViewController(conversationListDataProvider: self.viewModel, conversation: self.conversationsDataSource.fetchedResultsController.object(at: indexPath))
        let conv = self.conversationsDataSource.fetchedResultsController.object(at: indexPath)
        let dialogTitle = (self.conversationsDataSource.fetchedResultsController.object(at: indexPath).participants)?.name ?? "Undefined"
        let connectedUserID = (self.conversationsDataSource.fetchedResultsController.object(at: indexPath).participants)?.userId ?? "Undefined"
        let conversationVC = self.assembly.conversationController(with: conv, dialogTitle: dialogTitle, connectedUserID: connectedUserID)
        //vc.connectedUserID = self.viewModel.getUserIdBy(username: dialogName)
        //viewController.conversation = self.conversationsDataSource.fetchedResultsController.object(at: indexPath)
        if searchController.isActive {
            self.searchController.dismiss(animated: true) { [weak self] in
                self?.navigationController?.pushViewController(conversationVC, animated: true)
            }
        } else {
            self.navigationController?.pushViewController(conversationVC, animated: true)
        }
    }
}
