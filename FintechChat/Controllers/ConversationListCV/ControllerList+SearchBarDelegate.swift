//
//  ControllerList+SearchBarDelegate.swift
//  FintechChat
//
//  Created by Ирина Улитина on 25/02/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

//MARK: SearchBarDelegate
extension ConversationListViewController: UISearchBarDelegate {
    func SetUpSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
        searchController.searchBar.delegate!.searchBar?(searchController.searchBar, textDidChange: "")
    }
    
    func fillSearchResultsDefault() {
        ConversationListDataProvider.shared.filterString = ""
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        ConversationListDataProvider.shared.filterString = searchText
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fillSearchResultsDefault()
    }
    
}

