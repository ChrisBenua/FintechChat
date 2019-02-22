//
//  MessageTableViewCell.swift
//  FintechChat
//
//  Created by Ирина Улитина on 21/02/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

protocol MessageCellConfiguration: class {
    var messageText: String? { get set }
}

protocol MessageCellExtendedConfiguration: MessageCellConfiguration {
    var isIncoming: Bool! { get set }
}

class MessageTableViewCell: UITableViewCell, MessageCellExtendedConfiguration {
    
    static let grayBubbleImage = UIImage(named: "bubble_my")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    static let blueBubbleImage = UIImage(named: "bubble_incoming")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    
    public static let cellId = "MessageTableViewCellID"
    
    private static let bubbleCornerRadius: CGFloat = 12
    
    lazy var bubbleBackgroundView: UIView = {
        let v = UIView()
        v.clipsToBounds = true
        //v.layer.cornerRadius = MessageTableViewCell.bubbleCornerRadius
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = -1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = MessageTableViewCell.grayBubbleImage
        //imageView.tintColor = UIColor(white: 0.90, alpha: 1)
        return imageView
    }()
    
    var currentConstraints = [NSLayoutConstraint]()
    
    var isIncoming: Bool!
    
    var messageText: String?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        Logger.log("reuse")
        NSLayoutConstraint.deactivate(currentConstraints)
        currentConstraints.remove(at: currentConstraints.count - 1)
    }
    
    func updateUI() {
        messageLabel.text = messageText
        NSLayoutConstraint.activate(currentConstraints)
    }
    
    func setup(messageText: String?, isIncoming: Bool) {
        self.messageText = messageText
        self.isIncoming = isIncoming
        
        if (isIncoming) {
            currentConstraints.append(contentsOf: [
                bubbleBackgroundView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12)
                ])
            //bubbleBackgroundView.backgroundColor = .green
            bubbleImageView.image = MessageTableViewCell.blueBubbleImage
            bubbleImageView.tintColor = .green
            
        } else {
            currentConstraints.append(bubbleBackgroundView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -12))
            //bubbleBackgroundView.backgroundColor = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
            bubbleImageView.image = MessageTableViewCell.grayBubbleImage
            bubbleImageView.tintColor = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        }
        updateUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.contentView.addSubview(bubbleImageView)
        self.contentView.addSubview(bubbleBackgroundView)

        bubbleImageView.anchor(top: self.bubbleBackgroundView.topAnchor, left: self.bubbleBackgroundView.leftAnchor, bottom: self.bubbleBackgroundView.bottomAnchor, right: self.bubbleBackgroundView.rightAnchor, paddingTop: -4, paddingLeft: -8, paddingBottom: -4, paddingRight: -4, width: 0, height: 0)
        //common autolayout
        
        bubbleBackgroundView.addSubview(messageLabel)
        
        currentConstraints.append(contentsOf: [
            
            bubbleBackgroundView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
            bubbleBackgroundView.widthAnchor.constraint(lessThanOrEqualTo: self.contentView.widthAnchor, multiplier: 0.75)
            
            ])
        messageLabel.anchor(top: bubbleBackgroundView.topAnchor, left: bubbleBackgroundView.leftAnchor, bottom: bubbleBackgroundView.bottomAnchor, right: bubbleBackgroundView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
