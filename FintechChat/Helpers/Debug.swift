//
//  Debug.swift
//  FintechChat
//
//  Created by Ирина Улитина on 09/02/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation


class State {
    var previousState: String = ""
    var currentState: String = ""
    
    init(startState: String) {
        previousState = startState
        currentState = ""
    }
}

class Logger {

    static let shouldPrintDebug: Bool = true

    static func debugOutput(_ message: String = #function) {
        if (shouldPrintDebug) {
            print(message)
        }
    }
}

class StateLogger {
    var state: State
    
    var callerName: String
    
    init(startState: String, callerName: String) {
        state = State(startState: startState)
        self.callerName = callerName
    }
    
    func printState(methodName: String) {
        Logger.debugOutput("\(callerName) moved from \(state.previousState) to \(state.currentState) in \(methodName)")

    }
    
    func moveToNewState(newState: String = #function, methodName: String = #function) {
        state.currentState = newState
        printState(methodName: methodName)
        state.previousState = newState
    }
    
}
