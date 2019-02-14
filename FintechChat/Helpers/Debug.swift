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

protocol Loggable {
    func debugOutput(_ message: String)
}

class DebugLogger: Loggable {
    func debugOutput(_ message: String) {
        print(message)
    }
}

class ReleaseLogger: Loggable {
    func debugOutput(_ message: String) {}
}

class Logger {

    private static let shared = Logger()
    
    private lazy var logger: Loggable = {
        #if DEBUG
        return DebugLogger()
        #else
        return ReleaseLogger()
        #endif
    }()
    
    func log(_ message: String) {
        logger.debugOutput(message)
    }
    
    public static func log(_ message: String) {
        shared.log(message)
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
        Logger.log("\(callerName) moved from \(state.previousState) to \(state.currentState) in \(methodName)")
    }
    
    func moveToNewState(newState: String = #function, methodName: String = #function) {
        state.currentState = newState
        printState(methodName: methodName)
        state.previousState = newState
    }
    
}
