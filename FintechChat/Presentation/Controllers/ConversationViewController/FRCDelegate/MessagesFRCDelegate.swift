//
//  MessagesFRCDelegate.swift
//  FintechChat
//
//  Created by Ирина Улитина on 04/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import CoreData

protocol IMessagesFetchResultController: NSFetchedResultsControllerDelegate {
    
    var viewController: IScrollableViewController? { get set }
}



class MessagesFRCDelegate: NSObject, IMessagesFetchResultController {
    weak var viewController: IScrollableViewController?
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.viewController?.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.viewController?.tableView.endUpdates()
        self.viewController?.scrollToBottom(animated: true)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.viewController?.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .move:
            self.viewController?.tableView.deleteRows(at: [indexPath!], with: .automatic)
            self.viewController?.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            self.viewController?.tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .delete:
            self.viewController?.tableView.deleteRows(at: [indexPath!], with: .automatic)
        }
    }
    
    
    init(viewController: IScrollableViewController) {
        self.viewController = viewController
    }
    
}
