//
//  Deque.swift
//  FintechChat
//
//  Created by Ирина Улитина on 16/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation

class Queue<T> {
    private var sourceArray: [T] = []
    private var beginIndex: Int = 0
    private var endIndex: Int = 0
    
    var count: Int {
        get {
            return endIndex - beginIndex
        }
    }
    
    func push(_ elem: T) {
        self.sourceArray.append(elem)
        self.endIndex += 1
    }
    
    func shrinkToFit(size: Int) {
        while self.count > size {
            self.popFront()
        }
    }
    
    func front() -> T? {
        if count == 0 {
            return nil
        }
        return sourceArray[beginIndex]
    }
    
    func popFront() {
        guard self.count != 0 else { return }
        self.beginIndex += 1
    }
}
