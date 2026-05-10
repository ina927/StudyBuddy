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
 
    // MARK: - Degrees
    static let degrees: [DegreeOption] = [
        .init(id: "bit",      title: "Bachelor of Information Technology"),
        .init(id: "bcs",      title: "Bachelor of Computer Science"),
        .init(id: "beng",     title: "Bachelor of Engineering (Honours)"),
        .init(id: "bengsci",  title: "Bachelor of Engineering Science"),
        .init(id: "bsci",     title: "Bachelor of Science"),
        .init(id: "bbus",     title: "Bachelor of Business"),
        .init(id: "blaw",     title: "Bachelor of Laws"),
        .init(id: "bdes",     title: "Bachelor of Design"),
        .init(id: "bdab",     title: "Bachelor of Design Architecture Building"),
        .init(id: "bhlt",     title: "Bachelor of Health Science"),
        .init(id: "bnurs",    title: "Bachelor of Nursing"),
        .init(id: "bmid",     title: "Bachelor of Midwifery"),
        .init(id: "bcomm",    title: "Bachelor of Communication"),
        .init(id: "bedu",     title: "Bachelor of Education"),
        .init(id: "bitbus",   title: "Bachelor of IT / Bachelor of Business"),
        .init(id: "bengbus",  title: "Bachelor of Engineering / Bachelor of Business"),
        .init(id: "bscicit",  title: "Bachelor of Science / Bachelor of Creative Intelligence and Innovation"),
    ]
 
    // MARK: - Subjects
    static let subjects: [SubjectOption] = [
        .init(id: "any",    code: "ANY",    name: "Any subject"),
 
        // IT
        .init(id: "31005",  code: "31005",  name: "Machine Learning"),
        .init(id: "31061",  code: "31061",  name: "Database Principles"),
        .init(id: "31097",  code: "31097",  name: "IT Operations Management"),
        .init(id: "31250",  code: "31250",  name: "Introduction to Data Analytics"),
        .init(id: "31251",  code: "31251",  name: "Data Structures and Algorithms"),
        .init(id: "31253",  code: "31253",  name: "Database Programming"),
        .init(id: "31255",  code: "31255",  name: "Finance and IT Professionals"),
        .init(id: "31260",  code: "31260",  name: "Fundamentals of Interaction Design"),
        .init(id: "31265",  code: "31265",  name: "Communication for IT Professionals"),
        .init(id: "31266",  code: "31266",  name: "Introduction to Information Systems"),
        .init(id: "31268",  code: "31268",  name: "Web Systems"),
        .init(id: "31271",  code: "31271",  name: "Database Fundamentals"),
        .init(id: "31272",  code: "31272",  name: "Project Management and the Professional"),
        .init(id: "31748",  code: "31748",  name: "Programming on the Internet"),
        .init(id: "31927",  code: "31927",  name: "Application Development with .NET"),
        .init(id: "32130",  code: "32130",  name: "Fundamentals of Data Analytics"),
        .init(id: "32146",  code: "32146",  name: "Data Visualisation and Visual Analytics"),
        .init(id: "32309",  code: "32309",  name: "Digital Forensics"),
        .init(id: "32513",  code: "32513",  name: "Advanced Data Analytics Algorithms"),
        .init(id: "32541",  code: "32541",  name: "Project Management"),
        .init(id: "32548",  code: "32548",  name: "Cybersecurity"),
        .init(id: "32555",  code: "32555",  name: "Fundamentals of Software Development"),
        .init(id: "32558",  code: "32558",  name: "Business Intelligence"),
        .init(id: "40005",  code: "40005",  name: "Advanced iOS Development"),
        .init(id: "41001",  code: "41001",  name: "Cloud Computing and Software as a Service"),
        .init(id: "41025",  code: "41025",  name: "Introduction to Software Development"),
        .init(id: "41026",  code: "41026",  name: "Advanced Software Development"),
        .init(id: "41039",  code: "41039",  name: "Programming 1"),
        .init(id: "41040",  code: "41040",  name: "Introduction to Artificial Intelligence"),
        .init(id: "41043",  code: "41043",  name: "Natural Language Processing"),
        .init(id: "41052",  code: "41052",  name: "Advanced Algorithms"),
        .init(id: "41113",  code: "41113",  name: "Software Development Studio"),
        .init(id: "41181",  code: "41181",  name: "Information Security and Management"),
        .init(id: "41182",  code: "41182",  name: "System Security"),
        .init(id: "41184",  code: "41184",  name: "Secure Programming and Penetration Testing"),
        .init(id: "41889",  code: "41889",  name: "Application Development in the iOS Environment"),
        .init(id: "42080",  code: "42080",  name: "Fundamentals of Information Systems"),
        .init(id: "42172",  code: "42172",  name: "Introduction to Artificial Intelligence"),
        .init(id: "42820",  code: "42820",  name: "Machine Learning Foundations"),
        .init(id: "42821",  code: "42821",  name: "Data Analytics Foundations"),
        .init(id: "42822",  code: "42822",  name: "Advanced Data Analytics"),
        .init(id: "42889",  code: "42889",  name: "iOS Application Development"),
        .init(id: "42892",  code: "42892",  name: "Applied Machine Learning"),
        .init(id: "42893",  code: "42893",  name: "Data Engineering Foundations"),
        .init(id: "43007",  code: "43007",  name: "Advanced Artificial Intelligence"),
        .init(id: "430031", code: "430031", name: "Python Programming for Data Processing"),
 
        // Engineering
        .init(id: "48023",  code: "48023",  name: "Programming Fundamentals"),
        .init(id: "48024",  code: "48024",  name: "Programming 2"),
        .init(id: "48033",  code: "48033",  name: "Internet of Things"),
        .init(id: "48221",  code: "48221",  name: "Engineering Computations"),
        .init(id: "48230",  code: "48230",  name: "Introduction to Engineering Projects"),
        .init(id: "48240",  code: "48240",  name: "Design and Innovation Fundamentals"),
        .init(id: "48310",  code: "48310",  name: "Introduction to Civil and Environmental Engineering"),
        .init(id: "48321",  code: "48321",  name: "Engineering Mechanics"),
        .init(id: "48331",  code: "48331",  name: "Mechanics of Solids"),
        .init(id: "48430",  code: "48430",  name: "Fundamentals of C Programming"),
        .init(id: "48433",  code: "48433",  name: "Software Architecture"),
        .init(id: "48510",  code: "48510",  name: "Introduction to Electrical and Electronic Engineering"),
        .init(id: "48520",  code: "48520",  name: "Electronics and Circuits"),
        .init(id: "48540",  code: "48540",  name: "Signals and Systems"),
        .init(id: "48610",  code: "48610",  name: "Introduction to Mechanical Engineering"),
        .init(id: "48730",  code: "48730",  name: "Cybersecurity"),
        .init(id: "41082",  code: "41082",  name: "Introduction to Data Engineering"),
        .init(id: "41099",  code: "41099",  name: "Introduction to Mechatronics Engineering"),
        .init(id: "41160",  code: "41160",  name: "Introduction to Biomedical Engineering"),
 
        // Science & Maths
        .init(id: "33130",  code: "33130",  name: "Mathematics 1"),
        .init(id: "33230",  code: "33230",  name: "Mathematics 2"),
        .init(id: "33116",  code: "33116",  name: "Design, Data, and Decisions"),
        .init(id: "35006",  code: "35006",  name: "Numerical Methods"),
        .init(id: "35255",  code: "35255",  name: "Forensic Statistics"),
 
        // Business
        .init(id: "20101",  code: "20101",  name: "Management Skills"),
        .init(id: "20104",  code: "20104",  name: "Introduction to Human Resource Management"),
        .init(id: "20105",  code: "20105",  name: "Innovation and Entrepreneurship"),
        .init(id: "20108",  code: "20108",  name: "Introduction to International Business"),
        .init(id: "20109",  code: "20109",  name: "Introduction to Strategy"),
        .init(id: "20507",  code: "20507",  name: "Corporate Finance"),
        .init(id: "21130",  code: "21130",  name: "Accounting for Business"),
        .init(id: "21905",  code: "21905",  name: "Business Finance"),
        .init(id: "23115",  code: "23115",  name: "Economics for Business"),
        .init(id: "23567",  code: "23567",  name: "Intermediate Microeconomics"),
        .init(id: "23568",  code: "23568",  name: "Intermediate Macroeconomics"),
        .init(id: "24108",  code: "24108",  name: "Marketing Principles"),
        .init(id: "24210",  code: "24210",  name: "Integrated Marketing Communications"),
 
        // Law
        .init(id: "70616",  code: "70616",  name: "Foundations of Law"),
        .init(id: "70106",  code: "70106",  name: "Legal Research and Writing"),
        .init(id: "77715",  code: "77715",  name: "Banking Law"),
    ]
 
    // MARK: - Vibes
    static let vibes: [String] = [
        "Silent Focus",
        "Casual Co-study",
        "Problem Solving",
        "Exam Sprint",
        "Assignment Sprint",
        "Peer Teaching",
        "Discussion Heavy",
    ]
 
    // MARK: - Floor plan asset names (from Assets.xcassets)
    private static let floorPlanAssets: [String: String] = [
        "Level 1":  "Building 2 level 5",
        "Level 2":  "Building 2 level 6",
        "Level 3":  "Building 2 level 7",
        "Level 4":  "Building 2 level 4",
        "Level 5":  "Building 2 level 5",
        "Level 6":  "Building 2 level 6",
        "Level 7":  "Building 2 level 7",
        "Level 8":  "Building 2 level 8",
        "Level 9":  "Building 2 level 6",
        "Level 10": "Building 2 level 10",
    ]
 
    // MARK: - Buildings
    static let buildings: [BuildingOption] = [
        .init(id: "cb01", code: "CB01", name: "Tower Building",
              floors: floors(cb: "CB01", levels: ["Level 2","Level 3","Level 4","Level 5","Level 6","Level 7"]),
              lat: -33.8836, long: 151.2009),
        .init(id: "cb02", code: "CB02", name: "UTS Central",
              floors: floors(cb: "CB02", levels: ["Level 4","Level 5","Level 6","Level 7","Level 8","Level 10"]),
              lat: -33.8837, long: 151.2002),
        .init(id: "cb03", code: "CB03", name: "Bon Marche Building",
              floors: floors(cb: "CB03", levels: ["Level 1","Level 2","Level 3","Level 4","Level 5"]),
              lat: -33.8837, long: 151.2017),
        .init(id: "cb04", code: "CB04", name: "Science Building",
              floors: floors(cb: "CB04", levels: ["Level 1","Level 2","Level 3","Level 4"]),
              lat: -33.8830, long: 151.2012),
        .init(id: "cb05", code: "CB05", name: "Haymarket Building",
              floors: floors(cb: "CB05", levels: ["Level 1","Level 2","Level 3","Level 4"]),
              lat: -33.8801, long: 151.2021),
        .init(id: "cb06", code: "CB06", name: "Peter Johnson Building (DAB)",
              floors: floors(cb: "CB06", levels: ["Level 1","Level 2","Level 3","Level 4","Level 5","Level 6"]),
              lat: -33.8831, long: 151.2021),
        .init(id: "cb07", code: "CB07", name: "Vicki Sara Building",
              floors: floors(cb: "CB07", levels: ["Level 1","Level 2","Level 3","Level 4","Level 5"]),
              lat: -33.8830, long: 151.1999),
        .init(id: "cb08", code: "CB08", name: "Chau Chak Wing Building",
              floors: floors(cb: "CB08", levels: ["Level 1","Level 2","Level 3","Level 4","Level 5","Level 6","Level 7"]),
              lat: -33.8809, long: 151.2013),
        .init(id: "cb09", code: "CB09", name: "Building 9",
              floors: floors(cb: "CB09", levels: ["Level 1","Level 2","Level 3","Level 4"]),
              lat: -33.8835, long: 151.2016),
        .init(id: "cb10", code: "CB10", name: "Fairfax Building",
              floors: floors(cb: "CB10", levels: ["Level 1","Level 2","Level 3","Level 4","Level 5","Level 6"]),
              lat: -33.8836, long: 151.1990),
        .init(id: "cb11", code: "CB11", name: "FEIT Building",
              floors: floors(cb: "CB11", levels: ["Level 4","Level 5","Level 6","Level 7","Level 8"]),
              lat: -33.8840, long: 151.1992),
    ]
 
    // MARK: - Helper
    private static func floors(cb: String, levels: [String]) -> [BuildingFloor] {
        levels.map { level in
            .init(
                id: "\(cb.lowercased())-\(level.replacingOccurrences(of: " ", with: "").lowercased())",
                name: level,
                floorPlanAssetName: floorPlanAssets[level] ?? "floorplan_sample"
            )
        }
    }
}
