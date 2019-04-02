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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print(self.fetchedResultsController.object(at: IndexPath(item: 0, section: section)).isOnline ? "OnlineBBOm" : "HistoryBBOm")
        return self.fetchedResultsController.sections![section].name
    }
}
