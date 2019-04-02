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
extension ConversationListViewController: ThemesViewControllerDelegate {
    func themesViewController(_ controller: ThemesViewController, didSelectTheme selectedTheme: UIColor) {
        logThemeChanging(selectedTheme: selectedTheme)
    }
}

extension ConversationListViewController {
    
    func logThemeChanging(selectedTheme: UIColor) {
        UserDefaults.saveNavigationBarColor(navBarColor: selectedTheme)
        
        changeAppearance()
        
    }
    
    func changeAppearance() {
        let selectedTheme = UserDefaults.getNavigationBarColor()
        
        self.navigationController?.navigationBar.barTintColor = selectedTheme
        
        UINavigationBar.appearance().barTintColor = selectedTheme
        
        (self.navigationController as? CustomNavigationController)?.isLightTheme = true
        
        if selectedTheme.cgColor.components![0] < 32.1 / 255 {
            (self.navigationController as? CustomNavigationController)?.isLightTheme = false
            UserDefaults.saveIsLightTheme(isLightTheme: false)
            
            //self.navigationItem.rightBarButtonItem?.tintColor = .blue
            
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
            UINavigationBar.appearance().tintColor = .white
            
            self.navigationController?.navigationBar.tintColor = .white
        } //черная тема
        else {
            (self.navigationController as? CustomNavigationController)?.isLightTheme = true
            UserDefaults.saveIsLightTheme(isLightTheme: true)
            
            //self.navigationItem.rightBarButtonItem?.tintColor = .black
            
            UINavigationBar.appearance().tintColor = .blue
            
            self.navigationController?.navigationBar.tintColor = .blue
            
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        }
    }
    
}
