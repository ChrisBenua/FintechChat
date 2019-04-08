//
//  ThemeModel.swift
//  FintechChat
//
//  Created by Ирина Улитина on 08/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation


protocol IThemeModel: IThemeViewControllerService {
    
}

class ThemeModel: IThemeModel {
    func saveIsLightTheme(isLightTheme: Bool) {
        self.service.saveIsLightTheme(isLightTheme: isLightTheme)
    }
    
    func getIsLightTheme() -> Bool {
        return self.service.getIsLightTheme()
    }
    
    func saveNavigationBarColor(navBarColor: UIColor) {
        self.service.saveNavigationBarColor(navBarColor: navBarColor)
    }
    
    func getNavigationBarColor() -> UIColor {
        return self.service.getNavigationBarColor()
    }
    
    private let service: IThemeViewControllerService
    
    init(service: IThemeViewControllerService) {
        self.service = service
    }
}
