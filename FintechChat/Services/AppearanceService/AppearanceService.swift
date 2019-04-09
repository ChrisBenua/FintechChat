//
//  AppearanceService.swift
//  FintechChat
//
//  Created by Ирина Улитина on 09/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

protocol IAppearanceService {
    func changeAppearance(navigationController: UINavigationController?)
}

class AppearanceService: IAppearanceService {
    func changeAppearance(navigationController: UINavigationController?) {
        let selectedTheme = UserDefaults.getNavigationBarColor()
        
        navigationController?.navigationBar.barTintColor = selectedTheme
        
        UINavigationBar.appearance().barTintColor = selectedTheme
        
        (navigationController as? CustomNavigationController)?.isLightTheme = true
        
        if selectedTheme.cgColor.components![0] < 32.1 / 255 {
            (navigationController as? CustomNavigationController)?.isLightTheme = false
            UserDefaults.saveIsLightTheme(isLightTheme: false)
            
            //self.navigationItem.rightBarButtonItem?.tintColor = .blue
            
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
            UINavigationBar.appearance().tintColor = .white
            
            navigationController?.navigationBar.tintColor = .white
        } //черная тема
        else {
            (navigationController as? CustomNavigationController)?.isLightTheme = true
            
            UserDefaults.saveIsLightTheme(isLightTheme: true)
            
            //self.navigationItem.rightBarButtonItem?.tintColor = .black
            
            UINavigationBar.appearance().tintColor = .blue
            
            navigationController?.navigationBar.tintColor = .blue
            
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        }
    }
    
}
