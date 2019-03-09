//
//  NotifyOperation.swift
//  FintechChat
//
//  Created by Ирина Улитина on 09/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit


class NotifyOperation: Operation {
    
    var myFailiableDependencies: [FailiableOperation] = []
    
    var failed: Bool {
        get {
            return myFailiableDependencies.contains(where: { (op) -> Bool in
                op.failed
            })
        }
    }
    
    init(_ failiableOperations: [FailiableOperation]) {
        self.myFailiableDependencies = failiableOperations
    }
}
