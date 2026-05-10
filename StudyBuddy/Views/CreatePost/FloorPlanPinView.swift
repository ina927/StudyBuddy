//
//  FloorPlanPinView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI

struct FloorButton: View {
    let floor: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(floor.replacingOccurrences(of: "Level ", with: "L"))
                .font(AppTheme.Typography.labelSmall)
                .foregroundStyle(isSelected ? .white : AppTheme.Colors.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppTheme.Spacing.xs)
                .background(isSelected ? AppTheme.Colors.primary : AppTheme.Colors.primaryPale)
                .cornerRadius(AppTheme.Radius.sm)
                .padding(.horizontal, AppTheme.Spacing.xxs)
        }
    }
}

struct FloorSidebar: View {
    let floors: [String]
    @Binding var selectedFloor: String
    let onFloorChange: (String) -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.xs) {
                ForEach(floors, id: \.self) { floor in
                    FloorButton(floor: floor, isSelected: selectedFloor == floor) {
                        selectedFloor = floor
                        onFloorChange(floor)
                    }
                }
            }
            .padding(.vertical, AppTheme.Spacing.sm)
        }
        .frame(width: 52)
        .background(AppTheme.Colors.surface)
    }
}

struct FloorPlanCanvas: View {
    @Binding var draft: CreatePostDraft
    let pulse: Bool

    var body: some View {
        ZStack {
            AppTheme.Colors.primaryPale.opacity(0.4)

            Image(draft.floorPlanAssetName)
                .resizable()
                .scaledToFit()
                .overlay {
                    GeometryReader { imageGeo in
                        VStack(spacing: 2) {
                            Text("I'm here")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(AppTheme.Colors.locationText)
                                .clipShape(Capsule())

                            Image(systemName: "mappin")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundStyle(AppTheme.Colors.locationText)
                                .scaleEffect(pulse ? 1.12 : 0.96)
                        }
                        .position(
                            x: draft.pinX * imageGeo.size.width,
                            y: draft.pinY * imageGeo.size.height
                        )
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let localX = min(max(value.location.x, 0), imageGeo.size.width)
                                    let localY = min(max(value.location.y, 0), imageGeo.size.height)
                                    draft.pinX = localX / max(imageGeo.size.width, 1)
                                    draft.pinY = localY / max(imageGeo.size.height, 1)
                                }
                        )
                    }
                }
        }
        .frame(height: 320)
    }
}

struct LocationPhotoSection: View {
    @Binding var image: UIImage?

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxs + 2) {
            HStack(spacing: 2) {
                Text("Location Photo")
                    .font(AppTheme.Typography.label.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.primary)
                Text("*")
                    .font(AppTheme.Typography.label)
                    .foregroundStyle(AppTheme.Colors.locationText)
            }
            ImagePickerView(selectedImage: $image)
        }
    }
}

struct FloorPlanPinView: View {
    @Binding var draft: CreatePostDraft
    let onNext: () -> Void
    @State private var pulse = false

    private var sameBuildingFloors: [String] {
        guard let building = MetadataStore.buildings.first(where: { $0.code == draft.buildingCode }) else {
            return ["Level 2", "Level 3", "Level 4", "Level 5"]
        }
        return building.floors.map(\.name)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("Drag the pin to your exact position on the floor map.")
                    .font(AppTheme.Typography.bodySmall)
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)

                HStack(spacing: 0) {
                    FloorSidebar(
                        floors: sameBuildingFloors,
                        selectedFloor: $draft.floor,
                        onFloorChange: updateFloorPlanForSelectedFloor
                    )

                    FloorPlanCanvas(draft: $draft, pulse: pulse)
                }
                .frame(height: 320)
                .cornerRadius(AppTheme.Radius.md)

                VStack(alignment: .leading, spacing: AppTheme.Spacing.xxs + 2) {
                    HStack(spacing: 2) {
                        Text("Location Description")
                            .font(AppTheme.Typography.label.weight(.semibold))
                            .foregroundStyle(AppTheme.Colors.primary)
                        Text("*")
                            .font(AppTheme.Typography.label)
                            .foregroundStyle(AppTheme.Colors.locationText)
                    }

                    TextField(
                        "Describe your location (room number, table area, etc.)",
                        text: $draft.locationDescription,
                        axis: .vertical
                    )
                    .font(AppTheme.Typography.bodyMedium)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                    .lineLimit(2, reservesSpace: true)
                    .padding(AppTheme.Spacing.md)
                    .background(AppTheme.Colors.surface)
                    .cornerRadius(AppTheme.Radius.lg)
                }

                LocationPhotoSection(image: $draft.postImage)

                Button {
                    onNext()
                } label: {
                    Text("Next")
                        .font(AppTheme.Typography.label.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.sm)
                        .background(draft.canProceedFromLocation ? AppTheme.Colors.primary : AppTheme.Colors.textTertiary)
                        .cornerRadius(AppTheme.Radius.md)
                }
                .disabled(!draft.canProceedFromLocation)
            }
            .padding(AppTheme.Spacing.md)
        }
        .background(AppTheme.Colors.background)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                pulse = true
            }
            updateFloorPlanForSelectedFloor(draft.floor)
        }
    }

    private func updateFloorPlanForSelectedFloor(_ floor: String) {
        guard
            let building = MetadataStore.buildings.first(where: { $0.code == draft.buildingCode }),
            let floorData = building.floors.first(where: { $0.name == floor })
        else { return }

        draft.floorPlanAssetName = floorData.floorPlanAssetName
    }
}
