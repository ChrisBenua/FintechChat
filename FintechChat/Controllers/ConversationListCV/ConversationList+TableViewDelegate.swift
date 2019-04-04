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
    
    private func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print(self.conversationsDataSource.fetchedResultsController.object(at: IndexPath(item: 0, section: section)).isOnline ? "OnlineBBOm" : "HistoryBBOm")
        return self.conversationsDataSource.fetchedResultsController.sections![section].name
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let dialogName = searchedConversations[indexPath.row].name!
        let viewController = ConversationViewController(conversationListDataProvider: self.viewModel, conversation: self.conversationsDataSource.fetchedResultsController.object(at: indexPath))
        viewController.dialogTitle = (self.conversationsDataSource.fetchedResultsController.object(at: indexPath).participants)?.name ?? "Undefined"
        //vc.connectedUserID = self.viewModel.getUserIdBy(username: dialogName)
        viewController.connectedUserID = (self.conversationsDataSource.fetchedResultsController.object(at: indexPath).participants)?.userId ?? "Undefined"
        //viewController.conversation = self.conversationsDataSource.fetchedResultsController.object(at: indexPath)
        if searchController.isActive {
            self.searchController.dismiss(animated: true) { [weak self] in
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
        } else {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
