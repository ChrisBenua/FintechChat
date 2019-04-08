//
//  UserProfileState.swift
//  FintechChat
//
//  Created by Ирина Улитина on 09/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit


struct UserProfileState: Equatable {
    
    public static var defaultImageData = #imageLiteral(resourceName: "placeholder-user").pngData()!
    
    var username: String?
    
    var profileImage: UIImage?
    
    var detailInfo: String?
    
    static func == (lhs: UserProfileState, rhs: UserProfileState) -> Bool {
        return lhs.username == rhs.username &&
               lhs.profileImage == rhs.profileImage &&
               lhs.detailInfo == rhs.detailInfo
    }
}
