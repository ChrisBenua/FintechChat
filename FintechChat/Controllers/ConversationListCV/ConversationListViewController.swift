//
//  ConversationListViewController.swift
//  FintechChat
//
//  Created by Ирина Улитина on 21/02/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ConversationListViewController: UIViewController {
    
    var viewModel = ConversationListDataProvider()
    
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
    
    lazy var fetchedResultsController: NSFetchedResultsController<Conversation> = {
        let frc = self.viewModel.generateConversationListFRC()
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch let err {
            print("Cant fetch in ConversationListVC")
            print(err)
        }
        return frc
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ConversationTableViewCell.self, forCellReuseIdentifier: ConversationTableViewCell.cellId)
        return tableView
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateConversation()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.listViewController = self
        
        StorageManager.shared.getUserProfileState { (state) in
            CommunicationManager.shared = CommunicationManager(username: state.username ?? "justUsername")
            CommunicationManager.shared.contollerDataProvider = self.viewModel
            }
        
        
        //ConversationListDataProvider.shared.listViewController = self
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
        setUpSearchBar()
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

extension ConversationListViewController: NSFetchedResultsControllerDelegate {
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
        self.tableView.reloadSectionIndexTitles()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //self.tableView.reloadSectionIndexTitles()
        self.tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
}

extension ConversationListViewController: UpdateConversationControllerDelegate {
    func updateConversation() {
        //searchedConversations = self.viewModel.allConversationListCellData()
        DispatchQueue.main.async {
            //self.tableView.reloadData()
        }
    }
    
    func onError(error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
