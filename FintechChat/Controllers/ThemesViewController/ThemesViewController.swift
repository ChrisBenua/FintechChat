//
//  ThemesViewController.swift
//  FintechChat
//
//  Created by Ирина Улитина on 03/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

class ThemesViewController: UIViewController {
    
    var externalClosure: ((UIColor) -> Void)!
    
    var model: Themes = Themes(colors: UIColor.init(red: 32.0 / 255, green: 32.0 / 255, blue: 32.0 / 255, alpha: 1.0), c1: UIColor.init(red: 247.0 / 255.0, green: 231.0 / 255.0, blue: 206.0 / 255.0, alpha: 1.0), c2: UIColor.white)
    
    lazy var themesButtons: [UIButton] = {
        let arr = [UIButton(), UIButton(), UIButton()]
        for buttonIndex in 0..<arr.count {
            arr[buttonIndex].setTitle("Тема \(i + 1)", for: .normal)
            arr[buttonIndex].layer.cornerRadius = 10
            arr[buttonIndex].backgroundColor = UIColor.init(red: 255.0 / 255.0, green: 250.0 / 255.0, blue: 205.0 / 255.0, alpha: 1.0)
            arr[buttonIndex].setTitleColor(UIColor.black, for: .normal)
            arr[buttonIndex].layer.borderWidth = 1
            arr[buttonIndex].layer.borderColor = UIColor.black.cgColor
            arr[buttonIndex].addTarget(self, action: #selector(themesButtonOnClick), for: .touchUpInside)
        }
        
        return arr
    }()
    
    let navBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5)
        
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Закрыть", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(closeButtonOnClick), for: .touchUpInside)
        
        return button
    }()
    
    @objc func themesButtonOnClick(_ sender: Any) {
        let index = themesButtons.index(of: sender as? UIButton)
        if index == 0 {
            self.view.backgroundColor = self.model.theme1()
        } else if index == 1 {
            self.view.backgroundColor = self.model.theme2()
        } else {
            self.view.backgroundColor = self.model.theme3()
        }
        
        externalClosure(self.view.backgroundColor!)
    }
    
    @objc func closeButtonOnClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
        self.view.addSubview(navBarView)
        self.navBarView.addSubview(closeButton)
        //self.view.translatesAutoresizingMaskIntoConstraints = false
        navBarView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        navBarView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1.0 / 9.0).isActive = true
        
        closeButton.anchor(top: nil, left: nil, bottom: self.navBarView.bottomAnchor, right: self.navBarView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 12, paddingRight: 16, width: 0, height: 0)
        
        let stackView = UIStackView(arrangedSubviews: [themesButtons[0], UIView(), themesButtons[1], UIView(), themesButtons[2]])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        stackView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4).isActive = true
        
        stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        
    }
    
    required init(completionHandler: @escaping (UIColor) -> Void) {
        super.init(nibName: nil, bundle: nil)
        
        self.externalClosure = completionHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
