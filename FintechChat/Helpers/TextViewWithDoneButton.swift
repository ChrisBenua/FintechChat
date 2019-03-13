//
//  TextViewWithDoneButton.swift
//  FintechChat
//
//  Created by Ирина Улитина on 13/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit


class TextViewWithDoneButton: UITextView {
    
    public static let toolBarHeight: CGFloat = 50
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addDoneButtonToKeyboard()
    }
    
    fileprivate func addDoneButtonToKeyboard() {
        let toolBar: UIToolbar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: TextViewWithDoneButton.toolBarHeight))
        toolBar.barStyle = .default
        
        let flexSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        
        toolBar.items = [flexSpaceButton, doneButton]
        toolBar.sizeToFit()
        self.inputAccessoryView = toolBar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}
