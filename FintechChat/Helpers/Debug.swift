//
//  Debug.swift
//  FintechChat
//
//  Created by Ирина Улитина on 09/02/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation

let shouldPrintDebug: Bool = true

func debugOutput(_ message: String) {
    if (shouldPrintDebug) {
        print(message)
    }
}
