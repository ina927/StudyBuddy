//
//  StudyPost.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import Foundation
import FirebaseCore


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
    
    func convertFirestore() -> [String: Any] {
        return [
            "hostUserID": hostUserID,
            "hostUsername": hostUsername,
            "hostYear": hostYear,
            "hostDegrees": hostDegrees,
            "hostMajor": hostMajor ?? "",
            "title": title,
            "bodyText": bodyText,
            "buildingCode": buildingCode,
            "buildingName": buildingName,
            "floor": floor,
            "locationDescription": locationDescription,
            "photoAssetName": photoAssetName ?? "",
            "subjects": subjects,
            "vibe": vibe,
            "capacity": capacity,
            "startTime": Timestamp(date: startTime),
            "endTime": Timestamp(date: endTime),
            "createdAt": Timestamp(date: createdAt),
            "statusOverride": statusOverride?.rawValue ?? ""
        ]
    }

    static func convertModel(id: String, data: [String: Any]) -> StudyPost? {
        guard let hostUserID = data["hostUserID"] as? String,
              let hostUsername = data["hostUsername"] as? String,
              let hostYear = data["hostYear"] as? String,
              let hostDegrees = data["hostDegrees"] as? [String],
              let title = data["title"] as? String,
              let bodyText = data["bodyText"] as? String,
              let buildingCode = data["buildingCode"] as? String,
              let buildingName = data["buildingName"] as? String,
              let floor = data["floor"] as? String,
              let locationDescription = data["locationDescription"] as? String,
              let subjects = data["subjects"] as? [String],
              let vibe = data["vibe"] as? String,
              let capacity = data["capacity"] as? Int,
              let startTime = (data["startTime"] as? Timestamp)?.dateValue(),
              let endTime = (data["endTime"] as? Timestamp)?.dateValue(),
              let createdAt = (data["createdAt"] as? Timestamp)?.dateValue()
        else { return nil }

        return StudyPost(
            id: id,
            hostUserID: hostUserID,
            hostUsername: hostUsername,
            hostYear: hostYear,
            hostDegrees: hostDegrees,
            hostMajor: data["hostMajor"] as? String,
            title: title,
            bodyText: bodyText,
            buildingCode: buildingCode,
            buildingName: buildingName,
            floor: floor,
            locationDescription: locationDescription,
            photoAssetName: data["photoAssetName"] as? String,
            subjects: subjects,
            vibe: vibe,
            capacity: capacity,
            startTime: startTime,
            endTime: endTime,
            createdAt: createdAt,
            statusOverride: Status(rawValue: data["statusOverride"] as? String ?? "")
        )
    }
}
