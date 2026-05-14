//
//  UserProfile.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import Foundation
import PhotosUI

private extension String {
    var nilIfBlank: String? { isEmpty ? nil : self }
}

struct UserProfile: Identifiable, Codable {
    let id: String
    var email: String
    var firstName: String
    var lastName: String
    var username: String
    var degrees: [String]
    var year: String
    var major: String?
    var avatarData: Data? = nil
    var profilePic: String?

    func convertFirestore() -> [String: Any] {
        var payload: [String: Any] = [
            "email": email,
            "firstName": firstName,
            "lastName": lastName,
            "username": username,
            "degrees": degrees,
            "year": year
        ]

        if let major, !major.isEmpty {
            payload["major"] = major
        }

        if let profilePic, !profilePic.isEmpty {
            payload["profilePic"] = profilePic
        }

        return payload
    }

    static func convertModel(id: String, data: [String: Any]) -> UserProfile? {
        guard let email = data["email"] as? String,
              let firstName = data["firstName"] as? String,
              let lastName = data["lastName"] as? String,
              let username = data["username"] as? String,
              let degrees = data["degrees"] as? [String],
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
            major: (data["major"] as? String)?.nilIfBlank,
            profilePic: (data["profilePic"] as? String)?.nilIfBlank
        )
    }
}
