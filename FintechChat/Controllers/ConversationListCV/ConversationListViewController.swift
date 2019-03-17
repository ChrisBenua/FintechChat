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
    let rowHeight: CGFloat = 80
    
    var sectionNames: [String] = ["Online"]
        
    let searchController = UISearchController(searchResultsController: nil)
    
    var searchedConversations = [ConversationCellConfiguration]()
    
    //var searchSplittedConversation = [[ConversationCellConfiguration]]()
    
    //var allConversations: [ConversationCellConfiguration] = [ConversationCellConfiguration]()
    
    //var allSplittedConversations: [[ConversationCellConfiguration]] = [[ConversationCellConfiguration]]()
    
    /*private func fillSplittedConversations() {
        let activeConversations = allConversations.filter({ $0.online })
        let inactiveConversations = allConversations.filter({ !$0.online })
        allSplittedConversations.removeAll()
        allSplittedConversations.append(activeConversations)
        allSplittedConversations.append(inactiveConversations)
    }*/
    
    /*private func fillWithData() {
        let names = ["Matthew McConaughey", "Anne Hathaway", "Jessica Chastain", "Mackenzie Foy", "Ellen Burstyn", "Matt Damon", "John Lithgow", "Michael Caine", "Casey Affleck", "Timothée Chalamet", "Wes Bentley", "Bill Irwin", "Josh Stewart", "Topher Grace", "David Gyasi", "Leah Cairns", "David Oyelowo", "Collette Wolfe", "William Devane", "Elyes Gabel "]
        let lastMessage = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna"
        
        for i in 0..<names.count {
            let message: String? = i % 5 == 0 ? nil : lastMessage
            let date: Date = i % 7 == 0 ? Date(timeIntervalSince1970: 1194779471) : Date()
            let model = ConversationCellModelHelper(name: names[i], message: message , date: date, online: i < 10, hasUnreadMessages: i % 3 == 0)
            allConversations.append(model)
        }
        fillSplittedConversations()
    }*/
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        
        tv.register(ConversationTableViewCell.self, forCellReuseIdentifier: ConversationTableViewCell.cellId)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConversationListDataProvider.shared.listViewController = self
        self.navigationController?.view.backgroundColor = .white
        self.navigationItem.title = "Tinkoff Chat"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "user"), style: .plain, target: self, action: #selector(profileButtonOnClick))
        //self.navigationItem.rightBarButtonItem?.tintColor = .blue
        
        (self.navigationController as? CustomNavigationController)?.themeDelegate = self
        
        self.changeAppearance()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Theme", style: .plain, target: self, action: #selector(themesButtonOnClick))
        
        self.view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        //self.fillWithData()
        SetUpSearchBar()
        self.tableView.reloadData()
    }
    
    @objc func themesButtonOnClick(_ sender: Any) {
        //uncomment it for using obj-c version
        let themesVC = ThemesViewController()
        themesVC.setDelegate(self)
        /*let themesVC = ThemesViewController { (color) in
            self.logThemeChanging(selectedTheme: color)
        }*/
        
        
        self.present(themesVC, animated: true, completion: nil)
    }
    
    @objc func profileButtonOnClick(_ sender: Any) {
        let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC")
        self.present(profileVC, animated: true, completion: nil)
    }
    
}


extension ConversationListViewController: UpdateConversationListControllerDelegate {
    func updateConversationList() {
        searchedConversations = ConversationListDataProvider.shared.allConversationListCellData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
