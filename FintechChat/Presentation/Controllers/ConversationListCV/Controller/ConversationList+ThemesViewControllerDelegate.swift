//
//  ConversationList+ThemesViewControllerDelegate.swift
//  FintechChat
//
//  Created by Ирина Улитина on 02/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit
//uncomment it for using  obj-c version

protocol IAppearanceChanging {
    func changeAppearance(navigationController: UINavigationController?)
}

extension ConversationListViewController {
    
    func logThemeChanging(selectedTheme: UIColor) {
        UserDefaults.saveNavigationBarColor(navBarColor: selectedTheme)
        
        self.model.changeAppearance(navigationController: self.navigationController)
        
    }
    
}
