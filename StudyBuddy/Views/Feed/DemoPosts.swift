//
//  DemoPosts.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import Foundation

enum DemoPosts {
    static let seed: [StudyPost] = [
        StudyPost(
            id: UUID().uuidString,
            hostUserID: "demo1",
            hostUsername: "zizhu",
            hostYear: "IT 3rd year",
            hostDegrees: ["Bachelor of IT"],
            hostMajor: "Data Science",
            title: "Looking for ML study partner!!",
            bodyText: "Working through 12301 assignments, need someone to review notes together.",
            buildingCode: "CB11",
            buildingName: "Building 11",
            floor: "Level 5",
            locationDescription: "Room 05.405",
            photoAssetName: "room_photo_1",
            subjects: ["ANY Any", "31266 Web Systems"],
            vibe: "Silent Focus",
            capacity: 4,
            startTime: .now.addingTimeInterval(-1800),
            endTime: .now.addingTimeInterval(5400),
            createdAt: .now.addingTimeInterval(-1200),
            statusOverride: nil
        ),
        StudyPost(
            id: UUID().uuidString,
            hostUserID: "demo2",
            hostUsername: "jihee",
            hostYear: "IT 1st year",
            hostDegrees: ["Bachelor of IT"],
            hostMajor: "Software Development",
            title: "Study group for iOS Dev class!",
            bodyText: "Let’s solve tutorial exercises and compare implementations.",
            buildingCode: "CB10",
            buildingName: "Building 10",
            floor: "Level 4",
            locationDescription: "Near south window tables",
            photoAssetName: "room_photo_2",
            subjects: ["31268 iOS Development"],
            vibe: "Problem Solving",
            capacity: 5,
            startTime: .now.addingTimeInterval(1200),
            endTime: .now.addingTimeInterval(7200),
            createdAt: .now.addingTimeInterval(-4200),
            statusOverride: nil
        ),
        StudyPost(
            id: UUID().uuidString,
            hostUserID: "demo3",
            hostUsername: "alex",
            hostYear: "IT 2nd year",
            hostDegrees: ["Bachelor of Science"],
            hostMajor: "Mathematics",
            title: "Math + coding mixed revision",
            bodyText: "Quick concept review then coding practice.",
            buildingCode: "CB05",
            buildingName: "Building 5",
            floor: "Level 3",
            locationDescription: "Long table beside printer area",
            photoAssetName: "room_photo_3",
            subjects: ["33130 Mathematics 1", "41039 Programming 1"],
            vibe: "Light Discussion",
            capacity: 3,
            startTime: .now.addingTimeInterval(-600),
            endTime: .now.addingTimeInterval(3600),
            createdAt: .now.addingTimeInterval(-7000),
            statusOverride: nil
        )
    ]
}
