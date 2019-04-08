//
//  ConversationsDataSource.swift
//  FintechChat
//
//  Created by Ирина Улитина on 04/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import CoreData

protocol IConversationTableViewDataSource: UITableViewDataSource {
    
    var fetchedResultsController: NSFetchedResultsController<Conversation> { get set }
    
    var viewModel: IConversationDataProvider { get set }
    
    func performFetch()

}

class ConversationDataSource: NSObject, IConversationTableViewDataSource {
    var viewModel: IConversationDataProvider
    
    var fetchedResultsController: NSFetchedResultsController<Conversation>
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in FRC")
        }
        Logger.log("Conversations Sections count \(sections.count)")
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
        
        cell.setup(model: cellData.toConversationModel())
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print(self.fetchedResultsController.object(at: IndexPath(item: 0, section: section)).isOnline ? "OnlineBBOm" : "HistoryBBOm")
        return self.fetchedResultsController.sections![section].name
    }
    
    init(viewModel: IConversationDataProvider) {
        self.viewModel = viewModel
        self.fetchedResultsController = self.viewModel.generateConversationListFRC()
        
    }
    
    func performFetch() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch let err {
            Logger.log("Cant perform fetch")
            Logger.log(err.localizedDescription)
        }
    }
    
}
