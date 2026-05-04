//
//  UserProfile.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import Foundation

struct UserProfile: Identifiable, Codable {
    let id: String
    var email: String
    var firstName: String
    var lastName: String
    var username: String
    var degrees: [String]
    var year: String
    var major: String?
}
