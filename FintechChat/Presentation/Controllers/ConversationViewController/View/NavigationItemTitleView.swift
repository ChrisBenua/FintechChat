//
//  NavigationItemTitleView.swift
//  FintechChat
//
//  Created by Ирина Улитина on 20/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

class NavigationItemTitleView: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UserDefaults.getIsLightTheme() ? UIColor.black: UIColor.white
        return label
    }()
    
    func opponentDidBecomeOnline() {
        let transition = CATransition()
        transition.duration = 1
        CATransaction.begin()
        
        CATransaction.setCompletionBlock {
            self.titleLabel.layer.add(transition, forKey: nil)
            self.titleLabel.textColor = .green
        }
        
        CATransaction.commit()
        
        UIView.animate(withDuration: 1, animations: {
            self.titleLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.titleLabel.layoutIfNeeded()
        }, completion: nil)
    }
    
    func opponentDidBecomeOffline() {
        let transition = CATransition()
        transition.duration = 1
        CATransaction.begin()
        
        CATransaction.setCompletionBlock {
            self.titleLabel.layer.add(transition, forKey: nil)
            self.titleLabel.textColor = UserDefaults.getIsLightTheme() ? .black: .white
        }
        
        CATransaction.commit()
        
        UIView.animate(withDuration: 1, animations: {
            self.titleLabel.transform = .identity
            self.titleLabel.layoutIfNeeded()
        }, completion: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.titleLabel)
        titleLabel.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
