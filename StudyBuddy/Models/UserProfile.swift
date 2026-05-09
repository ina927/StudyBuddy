//
//  UserProfile.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import Foundation
import PhotosUI

struct UserProfile: Identifiable, Codable {
    let id: String
    var email: String
    var firstName: String
    var lastName: String
    var username: String
    var degrees: [String]
    var year: String
    var major: String?
    var profilePic: String?
    
    func convertFirestore() -> [String: Any] {
        return [
            "email": email,
            "firstName": firstName,
            "lastName": lastName,
            "username": username,
            "degrees": degrees,
            "year": year,
            "major": major ?? "",
            "profilePic": profilePic ?? ""
        ]
    }

    static func convertModel(id: String, data: [String: Any]) -> UserProfile? {
        guard let email = data["email"] as? String,
              let firstName = data["firstName"] as? String,
              let lastName = data["lastName"] as? String,
              let username = data["username"] as? String,
              let degrees = data["degrees"] as? [String],
              let profilePic = data["profilePic"] as? String,
              let year = data["year"] as? String
        else { return nil }
              
        

        return UserProfile(
            id: id,
            email: email,
            firstName: firstName,
            lastName: lastName,
            username: username,
            degrees: degrees,
            year: year,
            major: data["major"] as? String,
            profilePic: profilePic
        )
    }
}
