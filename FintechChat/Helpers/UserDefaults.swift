//
//  UserDefaults.swift
//  FintechChat
//
//  Created by Ирина Улитина on 03/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit


extension UserDefaults {
    static let navigationBarColorKey = "bavigationBarColorKey"
    static let isLightThemeKey = "isLightThemeKey"
    
    static func saveIsLightTheme(isLightTheme: Bool) {
        let data = NSKeyedArchiver.archivedData(withRootObject: isLightTheme)
        UserDefaults.standard.set(data, forKey: isLightThemeKey)
    }
    
    static func getIsLightTheme() -> Bool {
        guard let data = UserDefaults.standard.data(forKey: isLightThemeKey) else  { return true }
        guard let isLightTheme = NSKeyedUnarchiver.unarchiveObject(with: data) as? Bool else { return true }
        return isLightTheme
    }

    static func saveNavigationBarColor(navBarColor: UIColor) {
        let data = NSKeyedArchiver.archivedData(withRootObject: navBarColor)
        UserDefaults.standard.set(data, forKey: UserDefaults.navigationBarColorKey)
    }
    
    static func getNavigationBarColor() -> UIColor {
        guard let data = UserDefaults.standard.data(forKey: UserDefaults.navigationBarColorKey) else { return UIColor.white }
        guard let navBarColor = NSKeyedUnarchiver.unarchiveObject(with: data) as? UIColor else { return UIColor.white }
        return navBarColor
    }
}
