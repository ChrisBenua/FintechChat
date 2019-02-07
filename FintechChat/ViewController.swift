//
//  ViewController.swift
//  FintechChat
//
//  Created by Ирина Улитина on 07/02/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    func printState(methodName: String) {
        if (shouldPrintStates) {
            print(methodName)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        printState(methodName: #function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printState(methodName: #function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        printState(methodName: #function)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        printState(methodName: #function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        printState(methodName: #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        printState(methodName: #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        printState(methodName: #function)
    }
}

