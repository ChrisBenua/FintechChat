//
//  KeyboardObservers.swift
//  FintechChat
//
//  Created by Ирина Улитина on 08/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func addObservers(showSelector: Selector, hideSelector: Selector) {
        NotificationCenter.default.addObserver(self, selector: showSelector, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: hideSelector, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
