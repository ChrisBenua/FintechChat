//
//  CustomNavigationController.swift
//  FintechChat
//
//  Created by Ирина Улитина on 03/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

protocol CustomNavigationControllerDelegate: class {
    func isLightThemeChanged(isLightTheme: Bool)
}

class CustomNavigationController: UINavigationController {
    
    var isLightTheme: Bool = true {
        didSet {
            themeDelegate?.isLightThemeChanged(isLightTheme: isLightTheme)
        }
    }
    
    weak var themeDelegate: CustomNavigationControllerDelegate?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if isLightTheme {
            return .default
        }
        return .lightContent
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        isLightTheme = UserDefaults.getIsLightTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
