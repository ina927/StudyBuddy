//
//  StudyPost.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import Foundation

struct StudyPost: Identifiable, Codable, Equatable {
    enum Status: String, Codable, CaseIterable {
        case notStarted = "Not Started"
        case ongoing = "Ongoing"
        case full = "Full"
        case finished = "Finished"
    }

    let id: String
    var hostUserID: String
    var hostUsername: String
    var hostYear: String
    var hostDegrees: [String]
    var hostMajor: String?

    var title: String
    var bodyText: String

    var buildingCode: String
    var buildingName: String
    var floor: String
    var locationDescription: String
    var photoAssetName: String?

    var subjects: [String]
    var vibe: String
    var capacity: Int

    var startTime: Date
    var endTime: Date
    var createdAt: Date
    var statusOverride: Status?

    var computedStatus: Status {
        if let override = statusOverride {
            return override
        }
        let now = Date()
        if now < startTime { return .notStarted }
        if now > endTime { return .finished }
        return .ongoing
    }
}
