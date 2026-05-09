//
//  FloorPlanPinView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import PhotosUI
import SwiftUI

struct FloorPlanPinView: View {
    @Binding var draft: CreatePostDraft
    let onNext: () -> Void
    @State private var photoItem: PhotosPickerItem?

    private var sameBuildingFloors: [String] {
        guard let building = MetadataStore.buildings.first(where: { $0.code == draft.buildingCode }) else {
            return ["Level 2", "Level 3", "Level 4", "Level 5"]
        }
        return building.floors.map(\.name)
    }

    var body: some View {
        VStack(spacing: 10) {

            Text("Move the pin to your exact location.")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(sameBuildingFloors, id: \.self) { floor in
                            Button(floor.replacingOccurrences(of: "Level ", with: "L")) {
                                draft.floor = floor
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .frame(width: 72)
                .background(Color(.secondarySystemBackground))

                ZStack {
                    Image(draft.floorPlanAssetName)
                        .resizable()
                        .scaledToFit()
                        .background(Color(.tertiarySystemBackground))

                    GeometryReader { geo in
                        Image(systemName: "mappin.circle.fill")
                            .font(.title)
                            .foregroundStyle(.red)
                            .position(x: draft.pinX * geo.size.width, y: draft.pinY * geo.size.height)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        draft.pinX = min(max(0, value.location.x / geo.size.width), 1)
                                        draft.pinY = min(max(0, value.location.y / geo.size.height), 1)
                                    }
                            )
                    }
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 4) {
                    Text("Location Description")
                    Text("*").foregroundStyle(.red)
                }
                TextField("Describe your current location (room number, table area, etc.)", text: $draft.locationDescription)
                    .textFieldStyle(.roundedBorder)

                HStack(spacing: 4) {
                    Text("Location Photo")
                    Text("*").foregroundStyle(.red)
                }

                ImagePickerView(selectedImage: $draft.postImage)
                    .frame(height: 160)

            }
            .padding(.horizontal)

            Button("Next") {
                onNext()
            }
            .buttonStyle(.borderedProminent)
            .disabled(!draft.canProceedFromLocation)
            .padding(.bottom, 8)
        }
    }
}
