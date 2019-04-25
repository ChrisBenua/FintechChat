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
    
    var logoService: ITinkoffLogosService
    
    var logoBarService: ITinkoffLogosService
    
    var viewModel: IConversationDataProvider
    
    let rowHeight: CGFloat = 80
    
    var sectionNames: [String] = ["Online"]
        
    let searchController = UISearchController(searchResultsController: nil)
    
    var searchedConversations = [ConversationCellConfiguration]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        
        tableView.register(ConversationTableViewCell.self, forCellReuseIdentifier: ConversationTableViewCell.cellId)
        return tableView
    }()
    
    var conversationsDataSource: IConversationTableViewDataSource
    
    var frcDelegate: IConversationFetchResultController?
    
    var model: IConversationListModel
    
    var assembly: IPresentationAssembly
    
    init(viewModel: IConversationDataProvider, model: IConversationListModel, assembly: IPresentationAssembly, conversationDataSource: IConversationTableViewDataSource, logoService: ITinkoffLogosService = TinkoffLogosService(), barService: ITinkoffLogosService = TinkoffLogosService()) {
        self.viewModel = viewModel
        self.assembly = assembly
        self.assembly.setCommunicatorDelegate(delegate: viewModel)
        self.model = model
        self.conversationsDataSource = ConversationDataSource(viewModel: self.viewModel)
        self.logoBarService = barService
        self.logoService = logoService
        super.init(nibName: nil, bundle: nil)
        self.frcDelegate = ConversationFRCDelegate(tableView: self.tableView)
        self.conversationsDataSource.fetchedResultsController.delegate = self.frcDelegate
        self.tableView.dataSource = self.conversationsDataSource
        
        //self.tableView.delegate = self.conversationsDataSource
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.listViewController = self
        
        
        //ConversationListDataProvider.shared.listViewController = self
        self.navigationController?.view.backgroundColor = .white
        self.navigationItem.title = "Tinkoff Chat"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "user"), style: .plain, target: self, action: #selector(profileButtonOnClick))
        //self.navigationItem.rightBarButtonItem?.tintColor = .blue
        
        (self.navigationController as? CustomNavigationController)?.themeDelegate = self
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Theme", style: .plain, target: self, action: #selector(themesButtonOnClick))
        
        self.view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        //self.fillWithData()
        setUpSearchBar()
        self.conversationsDataSource.performFetch()
        self.tableView.reloadData()
        self.model.changeAppearance(navigationController: self.navigationController)
        self.addTinkoffTapListener()
    }
    
    @objc func themesButtonOnClick(_ sender: Any) {
        //uncomment it for using obj-c version
        let thVC = self.assembly.themesViewController { (color) in
            self.logThemeChanging(selectedTheme: color)
        }
        self.present(thVC, animated: true, completion: nil)
    }
    
    @objc func profileButtonOnClick(_ sender: Any) {
        let profile = self.assembly.profileViewController()
        
        self.present(profile, animated: true, completion: nil)
    }
    
}

extension ConversationListViewController: UpdateConversationControllerDelegate {
    func onError(error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ConversationListViewController: ITinkoffLogosController {
    func addTinkoffTapListener() {
        self.logoService.setup(view: self.tableView, time: 0.2)
        self.logoBarService.setup(view: self.navigationController!.navigationBar, time: 0.2)
    }
    
    
}
