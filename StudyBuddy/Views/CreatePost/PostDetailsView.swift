//
//  PostDetailsView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI

struct PostDetailsView: View {
    @EnvironmentObject private var appState: AppState
    @Binding var draft: CreatePostDraft
    let onPosted: () -> Void

    @State private var subjectSelection = ""

    var body: some View {
        Form {
            Section("Location") {
                Label("\(draft.buildingCode) \(draft.floor)", systemImage: "building.2")
                Label(draft.locationDescription, systemImage: "mappin.and.ellipse")
            }

            Section("Post") {
                TextField("Title *", text: $draft.title)
                TextField("Post Body *", text: $draft.postBody, axis: .vertical)
                    .lineLimit(6, reservesSpace: true)
            }

            Section("Session") {
                DatePicker("Start Time *", selection: $draft.startTime)
                DatePicker("End Time *", selection: $draft.endTime)

                if draft.endTime <= draft.startTime {
                    Text("End time must be later than start time.")
                        .font(.caption)
                        .foregroundStyle(.red)
                }

                MultiSelectDropdown(
                    placeholder: "Search subject",
                    options: MetadataStore.subjects.map(\.label),
                    selectedItems: $draft.subjects,
                    maxSelection: 3
                )

                Picker("Vibe *", selection: $draft.vibe) {
                    ForEach(MetadataStore.vibes, id: \.self) { Text($0) }
                }

                Stepper("Capacity *: \(draft.capacity)", value: $draft.capacity, in: 1...20)
            }
            
            Button("Post") {
                    appState.addPost(from: draft)
                    onPosted()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .disabled(!draft.canPost)
        }
    }
}
