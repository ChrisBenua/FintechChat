//
//  ProfileVC+TextViewDelegate.swift
//  FintechChat
//
//  Created by Ирина Улитина on 09/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

extension ProfileViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        lastFirstResponderFrame = textView.frame
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.editingAdapter.toggleEditingButtons(isEditing: true)
        //self.toggleEditingButtons(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        lastFirstResponderFrame = textField.frame
        
        return true
    }

}
