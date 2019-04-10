//
//  EditingAdapter.swift
//  FintechChat
//
//  Created by Ирина Улитина on 10/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit


protocol IHiddenButtonsAdapter {
    func toggleHidden(isEditing: Bool)
    
    func toggleEditingButtons(isEditing: Bool)
    
    var defaultHiddenButtons: [UIButton] { get set }
    
    var invertedHiddenButtons: [UIButton] { get set }
}


protocol IEditingGesturesAdapter {
    func toggleEditing(isEditing: Bool)

    var defaultEditingGestures: [UIGestureRecognizer] { get set }
    
    var invertedEditingGestures: [UIGestureRecognizer] { get set }
}

protocol IEditingInputFieldsAdapter {
    func toggleEditingInputFields(isEditing: Bool)
    
    var defaultEditingTextFields: [UIView] { get set }
    
    var invertedEditingTextFields: [UIView] { get set }
}

protocol IEditingClosuresAdapter {
    func toggleEditing(isEditing: Bool)
    
    var defaultEditingClosures: [(Bool) -> Void] { get set }
    
    var invertedEditingClosures: [(Bool) -> Void] { get set }
}

protocol IEditingAdapter: IHiddenButtonsAdapter, IEditingGesturesAdapter, IEditingClosuresAdapter, IEditingInputFieldsAdapter {

    
    func addClosures(defaultClosures: [(Bool) -> Void], invertedClosures: [(Bool) -> Void])
    
    func addTextFields(defaultsTextFields: [UIView], invertedTextFields: [UIView])
    
    func addButtons(defaultButtons: [UIButton], invertedButtons: [UIButton])
    
    func addGestures(defaultGestures: [UIGestureRecognizer], invertedGestures: [UIGestureRecognizer])
    
}

class EditingAdapter: IEditingAdapter {
    func toggleEditingButtons(isEditing: Bool) {
        invertedHiddenButtons.forEach({ $0.isEnabled = isEditing })
    }
    
    
    func toggleEditingInputFields(isEditing: Bool) {
        defaultEditingTextFields.forEach({ $0.isUserInteractionEnabled = isEditing })
        invertedEditingTextFields.forEach({ $0.isUserInteractionEnabled = isEditing })
    }
    
    
    func toggleHidden(isEditing: Bool) {
        defaultHiddenButtons.forEach({ $0.isHidden = isEditing })
        invertedHiddenButtons.forEach({ $0.isHidden = !isEditing })
    }
    
    
    var defaultEditingTextFields: [UIView] = []
    
    var invertedEditingTextFields: [UIView] = []
    
    var defaultEditingClosures: [(Bool) -> Void] = []
    
    var invertedEditingClosures: [(Bool) -> Void] = []
    
    
    var defaultEditingGestures: [UIGestureRecognizer] = []
    
    var invertedEditingGestures: [UIGestureRecognizer] = []
    
    var defaultHiddenButtons: [UIButton] = []
    
    var invertedHiddenButtons: [UIButton] = []
    
    func toggleEditing(isEditing: Bool) {
        //defaultEditing.forEach({ $0.is })
        defaultHiddenButtons.forEach({ $0.isHidden = isEditing })
        invertedHiddenButtons.forEach({ $0.isHidden = !isEditing })
        defaultEditingGestures.forEach({ $0.isEnabled = isEditing })
        invertedEditingGestures.forEach({ $0.isEnabled = !isEditing })
        defaultEditingClosures.forEach({ $0(isEditing) })
        invertedEditingClosures.forEach({ $0(!isEditing) })
        defaultEditingTextFields.forEach({ $0.isUserInteractionEnabled = isEditing })
        invertedEditingTextFields.forEach({ $0.isUserInteractionEnabled = !isEditing })
    }
    
    func addClosures(defaultClosures: [(Bool) -> Void], invertedClosures: [(Bool) -> Void]) {
        self.defaultEditingClosures = defaultClosures
        self.invertedEditingClosures = invertedClosures
    }
    
    func addTextFields(defaultsTextFields: [UIView], invertedTextFields: [UIView]) {
        self.defaultEditingTextFields = defaultsTextFields
        self.invertedEditingTextFields = invertedTextFields
    }
    
    func addButtons(defaultButtons: [UIButton], invertedButtons: [UIButton]) {
        self.defaultHiddenButtons = defaultButtons
        self.invertedHiddenButtons = invertedButtons
    }
    
    func addGestures(defaultGestures: [UIGestureRecognizer], invertedGestures: [UIGestureRecognizer]) {
        self.defaultEditingGestures = defaultGestures
        self.invertedEditingGestures = invertedGestures
    }
    
    
}
