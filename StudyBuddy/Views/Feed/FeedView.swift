//
//  FeedView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject private var appState: AppState

    @State private var query = ""
    @State private var building = "All"
    @State private var vibe = "All"
    @State private var showAllStatus = false
    @State private var showMoreFilters = false

    @State private var degree = "All"
    @State private var major = "All"

    @State private var timePreset: String = "Now"

    private let timeOptions = ["Now", "Next 2h", "Custom"]
    @State private var customFrom = Date()
    @State private var customTo = Date().addingTimeInterval(7200)

    private var filtered: [StudyPost] {
        let now = Date()

        return appState.posts.filter { post in
            let statusPass = showAllStatus ? true : post.computedStatus == .ongoing
            let buildingPass = building == "All" || post.buildingCode == building
            let vibePass = vibe == "All" || post.vibe == vibe

            let timePass: Bool
            switch timePreset {
            case "Now":
                timePass = post.startTime <= now && post.endTime >= now
            case "Next 2h":
                let limit = now.addingTimeInterval(7200)
                timePass = post.startTime <= limit && post.endTime >= now
            default:
                timePass = post.startTime <= customTo && post.endTime >= customFrom
            }

            let degreePass = degree == "All" || post.hostDegrees.contains(degree)
            let majorPass = major == "All" || (post.hostMajor ?? "") == major

            let queryPass = query.isEmpty
                || post.title.localizedCaseInsensitiveContains(query)
                || post.bodyText.localizedCaseInsensitiveContains(query)

            return statusPass && buildingPass && vibePass && timePass && degreePass && majorPass && queryPass
        }
        .sorted { $0.createdAt > $1.createdAt }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                TextField("Search posts...", text: $query)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                HStack(spacing: 8) {
                    FilterMenuChip(title: "Building", value: $building, items: ["All"] + MetadataStore.buildings.map(\.code))
                    FilterMenuChip(title: "Vibe", value: $vibe, items: ["All"] + MetadataStore.vibes)
                    FilterMenuChip(title: "Time", value: $timePreset, items: timeOptions)
                }
                .padding(.horizontal)

                HStack {
                    Toggle("Show all status", isOn: $showAllStatus)
                    Spacer()
                    Button("More Filters") { showMoreFilters = true }
                        .buttonStyle(.bordered)
                }
                .padding(.horizontal)

                if filtered.isEmpty {
                    Spacer()
                    Text("No posts found.")
                        .foregroundStyle(.secondary)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 14) {
                            ForEach(filtered) { post in
                                NavigationLink {
                                    PostDetailView(post: post)
                                } label: {
                                    PostCardView(post: post)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("StudyBuddy")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showMoreFilters) {
                NavigationStack {
                    Form {
                        Picker("Degree", selection: $degree) {
                            Text("All").tag("All")
                            ForEach(MetadataStore.degrees.map(\.title), id: \.self) { Text($0).tag($0) }
                        }

                        Picker("Major", selection: $major) {
                            Text("All").tag("All")
                            ForEach(uniqueMajors, id: \.self) { Text($0).tag($0) }
                        }

                        if timePreset == "Custom" {
                            DatePicker("From", selection: $customFrom)
                            DatePicker("To", selection: $customTo)
                        }
                    }
                    .navigationTitle("More Filters")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }

    private var uniqueMajors: [String] {
        let m = appState.posts.compactMap(\.hostMajor).filter { !$0.isEmpty }
        return Array(Set(m)).sorted()
    }
}

struct FilterMenuChip: View {
    let title: String
    @Binding var value: String
    let items: [String]

    var body: some View {
        Menu {
            ForEach(items, id: \.self) { item in
                Button(item) { value = item }
            }
        } label: {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.subheadline)
                    .lineLimit(1)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, minHeight: 52, alignment: .leading)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
