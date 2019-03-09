//
//  SaveManager.swift
//  FintechChat
//
//  Created by Ирина Улитина on 09/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit


class FetchSaveManager {
    
    public static func getBaseURL() throws -> URL {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw SavingErrors.directoryNotFound
        }
        return dir
    }
    
    public static func saveStringToFile(text: String, _ endPoint: String) throws {
        try text.write(to: getBaseURL().appendingPathComponent(endPoint), atomically: false, encoding: .utf8)
    }
    
    public static func saveProfileImageToFile(profileImage: UIImage, _ endPoint: String) throws {
        try profileImage.jpegData(compressionQuality: 1.0)?.write(to: getBaseURL().appendingPathComponent(endPoint))
    }
    
    public static func getSavedStringFromFile(_ endPoint: String) throws -> String {
        return try String(contentsOf: getBaseURL().appendingPathComponent(endPoint), encoding: .utf8)
    }
    
    public static func getSavedProfileImage() throws -> UIImage? {
        let data = try Data(contentsOf: getBaseURL().appendingPathComponent(DataManagersFilePaths.userProfileImageFile))
        
        return UIImage(data: data)
    }
}
