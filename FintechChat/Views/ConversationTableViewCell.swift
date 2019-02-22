//
//  ConversationTableViewCell.swift
//  FintechChat
//
//  Created by Ирина Улитина on 21/02/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

protocol ConversationCellConfiguration : class {
    var name: String? { get set }
    var message: String? { get set }
    var date: Date? { get set }
    var online: Bool { get set }
    var hasUnreadMessages: Bool { get set }
}

class ConversationTableViewCell: UITableViewCell, ConversationCellConfiguration {
    
    public static let cellId = "ConversationCellID"
    
    var name: String?
    
    var message: String?
    
    var date: Date?
    
    var online: Bool = false
    
    var hasUnreadMessages: Bool = false
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let lastMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 2
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    func updateUI() {
        self.nameLabel.text = self.name
        if let msg = self.message {
            self.lastMessageLabel.font = UIFont.systemFont(ofSize: 14)
            self.lastMessageLabel.text = msg
        } else {
            self.lastMessageLabel.font = UIFont.boldSystemFont(ofSize: 18)
            self.lastMessageLabel.text = "No Messages Yet"
        }
        
        if let date = self.date {
            let dateFormatter = DateFormatter()
            let calender = Calendar.current
            
            let messageDateComponents = calender.dateComponents(Set<Calendar.Component>(arrayLiteral: .day, .month, .year), from: date)
            let currentDateComponents = calender.dateComponents(Set<Calendar.Component>(arrayLiteral: .day, .month, .year), from: Date())

            if messageDateComponents.day == currentDateComponents.day &&
                messageDateComponents.month == currentDateComponents.month &&
                messageDateComponents.year == currentDateComponents.year {
                
                dateFormatter.dateFormat = "HH:mm"
            } else {
                
                dateFormatter.dateFormat = "dd MMM"
            }
            self.dateLabel.text = dateFormatter.string(from: date)
        }
        
        if self.online {
            self.backgroundColor = UIColor(red: 255/255, green: 250/255, blue: 205/255, alpha: 1)
        } else {
            self.backgroundColor = .white
        }
        
        if self.hasUnreadMessages {
            self.lastMessageLabel.font = UIFont.boldSystemFont(ofSize: 14)
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //self.backgroundColor = .white
    }
    
    func setup(name: String?, message: String?, date: Date?, online: Bool, hasUnreadMessages: Bool) {
        self.name = name
        self.message = message
        self.date = date
        self.online = online
        self.hasUnreadMessages = hasUnreadMessages
        updateUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        //autolyaout
        self.contentView.addSubview(lastMessageLabel)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(nameLabel)
        
        nameLabel.anchor(top: self.contentView.topAnchor, left: self.contentView.leftAnchor, bottom: lastMessageLabel.topAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)
        
        nameLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 252), for: .vertical)
        lastMessageLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .vertical)
        nameLabel.rightAnchor.constraint(lessThanOrEqualTo: dateLabel.leftAnchor, constant: 8).isActive = true
        dateLabel.anchor(top: nil, left: nil, bottom: lastMessageLabel.topAnchor, right: self.contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
        lastMessageLabel.anchor(top: nil, left: self.contentView.leftAnchor, bottom: self.contentView.bottomAnchor, right: self.contentView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 4, paddingRight: 8, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
