//
//  ConversationListCV+CustomNavigationControllerDelegate.swift
//  FintechChat
//
//  Created by Ирина Улитина on 06/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

extension ConversationListViewController: CustomNavigationControllerDelegate {
    func isLightThemeChanged(isLightTheme: Bool) {
        if isLightTheme {
            self.navigationItem.rightBarButtonItem?.tintColor = .black
        } else {
            self.navigationItem.rightBarButtonItem?.tintColor = .white
        }
    }
}
