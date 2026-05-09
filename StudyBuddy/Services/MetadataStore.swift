//
//  MetadataStore.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import Foundation

struct DegreeOption: Identifiable, Codable, Hashable {
    let id: String
    let title: String
}

struct SubjectOption: Identifiable, Codable, Hashable {
    let id: String
    let code: String
    let name: String

    var label: String { "\(code) \(name)" }
}

struct BuildingFloor: Identifiable, Hashable {
    let id: String
    let name: String
    let floorPlanAssetName: String
}

struct BuildingOption: Identifiable, Hashable {
    let id: String
    let code: String
    let name: String
    let floors: [BuildingFloor]
    let lat: Double
    let long: Double
    var label: String { "\(code) \(name)" }
}

struct MetadataStore {
    static let degrees: [DegreeOption] = [
        .init(id: "bit", title: "Bachelor of IT"),
        .init(id: "bsci", title: "Bachelor of Science"),
        .init(id: "beng", title: "Bachelor of Engineering"),
        .init(id: "bdes", title: "Bachelor of Design"),
        .init(id: "bbus", title: "Bachelor of Business")
    ]

    static let subjects: [SubjectOption] = [
        .init(id: "any", code: "ANY", name: "Any"),
        .init(id: "31266", code: "31266", name: "Web Systems"),
        .init(id: "31268", code: "31268", name: "iOS Development"),
        .init(id: "41039", code: "41039", name: "Programming 1"),
        .init(id: "48024", code: "48024", name: "Data Analytics"),
        .init(id: "33130", code: "33130", name: "Mathematics 1"),
        .init(id: "70102", code: "70102", name: "Finance Basics")
    ]

    static let vibes: [String] = [
        "Silent Focus",
        "Casual Co-study",
        "Problem Solving",
        "Exam Revision",
        "Assignment Sprint",
        "Peer Teaching",
        "Discussion Heavy",
        "Accountability Session"
    ]

    static let buildings: [BuildingOption] = [
        .init(id: "cb01", code: "CB01", name: "Building 1", floors: floors(cb: "CB01", levels: ["Level 2","Level 3","Level 4","Level 5"]), lat: -33.8836203421038, long: 151.2008799827559),
        .init(id: "cb02", code: "CB02", name: "Building 2", floors: floors(cb: "CB02", levels: ["Level 3","Level 4","Level 5","Level 6"]), lat: -33.88371586599002, long: 151.20019317711268),
        .init(id: "cb03", code: "CB03", name: "Building 3", floors: floors(cb: "CB03", levels: ["Level 1","Level 2","Level 3"]), lat: -33.883710291349736, long: 151.20172850689087),
        .init(id: "cb04", code: "CB04", name: "Building 4", floors: floors(cb: "CB04", levels: ["Level 2","Level 3","Level 4"]), lat: -33.88297082849164, long: 151.2012321625357),
        .init(id: "cb05", code: "CB05", name: "Building 5", floors: floors(cb: "CB05", levels: ["Level 1","Level 2","Level 3","Level 4"]), lat: -33.88005519185811, long: 151.2021271387668),
        .init(id: "cb06", code: "CB06", name: "Building 6", floors: floors(cb: "CB06", levels: ["Level 2","Level 3","Level 4","Level 5"]), lat: -33.88307831160652, long: 151.2021423499492),
        .init(id: "cb07", code: "CB07", name: "Building 7", floors: floors(cb: "CB07", levels: ["Level 1","Level 2","Level 3","Level 4","Level 5"]), lat: -33.88301395586287, long: 151.19987074568087),
        .init(id: "cb08", code: "CB08", name: "Building 8", floors: floors(cb: "CB08", levels: ["Level 2","Level 3","Level 4"]), lat: -33.88091379646525, long: 151.20126820465887),
        .init(id: "cb09", code: "CB09", name: "Building 9", floors: floors(cb: "CB09", levels: ["Level 1","Level 2","Level 3","Level 4"]), lat: -33.88350294848451, long: 151.20157838486023),
        .init(id: "cb10", code: "CB10", name: "Building 10", floors: floors(cb: "CB10", levels: ["Level 2","Level 3","Level 4","Level 5","Level 6"]), lat: -33.88359456589195, long: 151.1990309265354),
        .init(id: "cb11", code: "CB11", name: "Building 11", floors: floors(cb: "CB11", levels: ["Level 2","Level 3","Level 4","Level 5","Level 6"]), lat: -33.88398260974563, long: 151.1991565131521)
    ]

    private static func floors(cb: String, levels: [String]) -> [BuildingFloor] {
        levels.map {
            .init(
                id: "\(cb.lowercased())-\($0.replacingOccurrences(of: " ", with: "").lowercased())",
                name: $0,
                floorPlanAssetName: "floorplan_sample"
            )
        }
    }
}
