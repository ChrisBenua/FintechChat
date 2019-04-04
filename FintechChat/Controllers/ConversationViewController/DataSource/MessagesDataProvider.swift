//
//  ConversationViewDataProvider.swift
//  FintechChat
//
//  Created by Ирина Улитина on 04/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import CoreData


protocol IMessageTableViewDataSource: UITableViewDataSource {
    var fetchedResultsController: NSFetchedResultsController<Message> { get set }
    
    var viewModel: IConversationDataProvider { get set }
    
    func performFetch()
}

class MessagesTableViewDataSource: NSObject, IMessageTableViewDataSource {
    var fetchedResultsController: NSFetchedResultsController<Message>
    
    var viewModel: IConversationDataProvider
    
    var conversation: Conversation
    
    func performFetch() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch let err {
            Logger.log("Cant perform fetch, OBAMA in MessagesTableViewDataSource")
            Logger.log(err.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in FRC")
        }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.cellId, for: indexPath) as? MessageTableViewCell else {
            fatalError("OBAMA, Wrong cell was dequed")
        }
        
        let message = self.fetchedResultsController.object(at: indexPath)
        
        let isIncoming = ((self.conversation.participants)?.userId ?? "NotExistingId") == (message.senderId ?? "NotExitstingId2")
        
        cell.setup(messageText: message.text ?? "", isIncoming: isIncoming)
        return cell
    }
    
    init(viewModel: IConversationDataProvider, conversation: Conversation) {
        self.viewModel = viewModel
        self.conversation = conversation
        self.fetchedResultsController = self.viewModel.generateConversationFRC(conversationId: conversation.conversationId!)//force unwrap for debug
    }
    
}
