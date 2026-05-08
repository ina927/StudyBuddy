//
//  CreatePostDraft.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import Foundation
import CoreGraphics
import PhotosUI

struct CreatePostDraft: Hashable {
    var buildingCode: String = ""
    var buildingName: String = ""
    var floor: String = ""
    var floorPlanAssetName: String = "floorplan_sample"

    var pinX: CGFloat = 0.5
    var pinY: CGFloat = 0.5
    var locationDescription: String = ""
    var photoAssetName: String? = nil

    var title: String = ""
    var postBody: String = ""
    var subjects: [String] = []
    var vibe: String = "Silent Focus"
    var capacity: Int = 4

    var startTime: Date = Date()
    var endTime: Date = Date().addingTimeInterval(3600)

    var canProceedFromLocation: Bool {
        !locationDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && photoAssetName != nil
    }

    var canPost: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !subjects.isEmpty &&
        endTime > startTime &&
        canProceedFromLocation
    }
}
