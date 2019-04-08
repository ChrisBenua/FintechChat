//
//  ThemeViewControllerService.swift
//  FintechChat
//
//  Created by Ирина Улитина on 05/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

protocol IThemeViewControllerService {
    
    func saveIsLightTheme(isLightTheme: Bool)
    
    func getIsLightTheme() -> Bool
    
    func saveNavigationBarColor(navBarColor: UIColor)
    
    func getNavigationBarColor() -> UIColor
}

class ThemeViewControllerService: IThemeViewControllerService {
    
    static let navigationBarColorKey = "bavigationBarColorKey"
    static let isLightThemeKey = "isLightThemeKey"
    private let savingThemeQueue = DispatchQueue(label: "ThemeSavingQueue", qos: .background, attributes: .concurrent)
    
    
    func saveIsLightTheme(isLightTheme: Bool) {
        let data = NSKeyedArchiver.archivedData(withRootObject: isLightTheme)
        UserDefaults.standard.set(data, forKey: ThemeViewControllerService.isLightThemeKey)
    }
    
    func getIsLightTheme() -> Bool {
        guard let data = UserDefaults.standard.data(forKey: ThemeViewControllerService.isLightThemeKey) else { return true }
        guard let isLightTheme = NSKeyedUnarchiver.unarchiveObject(with: data) as? Bool else { return true }
        return isLightTheme
    }
    
    func saveNavigationBarColor(navBarColor: UIColor) {
        savingThemeQueue.async(flags: .barrier) {
            let data = NSKeyedArchiver.archivedData(withRootObject: navBarColor)
            UserDefaults.standard.set(data, forKey: UserDefaults.navigationBarColorKey)
        }
    }
    
    func getNavigationBarColor() -> UIColor {
        return savingThemeQueue.sync {
            guard let data = UserDefaults.standard.data(forKey: UserDefaults.navigationBarColorKey) else { return UIColor.white }
            guard let navBarColor = NSKeyedUnarchiver.unarchiveObject(with: data) as? UIColor else { return UIColor.white }
            return navBarColor
        }
    }
}
