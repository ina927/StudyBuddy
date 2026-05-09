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
                    ScrollView {
                        VStack(spacing: AppTheme.Spacing.xs) {
                            ForEach(sameBuildingFloors, id: \.self) { floor in
                                Button(floor.replacingOccurrences(of: "Level ", with: "L")) {
                                    draft.floor = floor
                                }
                                .font(AppTheme.Typography.labelSmall)
                                .foregroundStyle(draft.floor == floor ? .white : AppTheme.Colors.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, AppTheme.Spacing.xs)
                                .background(draft.floor == floor ? AppTheme.Colors.primary : AppTheme.Colors.primaryPale)
                                .cornerRadius(AppTheme.Radius.sm)
                                .padding(.horizontal, AppTheme.Spacing.xxs)
                            }
                        }
                        .padding(.vertical, AppTheme.Spacing.sm)
                    }
                    .frame(width: 52)
                    .background(AppTheme.Colors.surface)

                    ZStack {
                        AppTheme.Colors.primaryPale.opacity(0.4)

                        Image(draft.floorPlanAssetName)
                            .resizable()
                            .scaledToFit()

                        GeometryReader { geo in
                            VStack(spacing: 2) {
                                Text("I’m here")
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
                                x: draft.pinX * geo.size.width,
                                y: draft.pinY * geo.size.height
                            )
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        draft.pinX = min(max(0, value.location.x / geo.size.width), 1)
                                        draft.pinY = min(max(0, value.location.y / geo.size.height), 1)
                                    }
                            )
                        }
                    }
                    .frame(height: 320)
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
                    TextField("Describe your location (room number, table area, etc.)", text: $draft.locationDescription, axis: .vertical)
                        .font(AppTheme.Typography.bodyMedium)
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                        .lineLimit(2, reservesSpace: true)
                        .padding(AppTheme.Spacing.md)
                        .background(AppTheme.Colors.surface)
                        .cornerRadius(AppTheme.Radius.lg)
                }

                VStack(alignment: .leading, spacing: AppTheme.Spacing.xxs + 2) {
                    HStack(spacing: 2) {
                        Text("Location Photo")
                            .font(AppTheme.Typography.label.weight(.semibold))
                            .foregroundStyle(AppTheme.Colors.primary)
                        Text("*")
                            .font(AppTheme.Typography.label)
                            .foregroundStyle(AppTheme.Colors.locationText)
                    }

                    PhotosPicker(selection: $photoItem, matching: .images) {
                        HStack(spacing: AppTheme.Spacing.sm) {
                            ZStack {
                                RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                                    .fill(AppTheme.Colors.primaryPale)
                                    .frame(width: 56, height: 56)
                                Image(systemName: draft.photoAssetName == nil ? "camera.fill" : "checkmark.circle.fill")
                                    .font(.system(size: 22))
                                    .foregroundStyle(AppTheme.Colors.primary)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(draft.photoAssetName == nil ? "Tap to add a photo" : "Photo selected ✓")
                                    .font(AppTheme.Typography.label)
                                    .foregroundStyle(AppTheme.Colors.primary)
                                Text(draft.photoAssetName == nil ? "Show where you are seated" : "Tap to change photo")
                                    .font(AppTheme.Typography.bodySmall)
                                    .foregroundStyle(AppTheme.Colors.textTertiary)
                            }

                            Spacer()
                        }
                        .padding(AppTheme.Spacing.sm)
                        .background(AppTheme.Colors.surface)
                        .cornerRadius(AppTheme.Radius.md)
                    }
                    .buttonStyle(.plain)
                }

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
        .onChange(of: photoItem) { _, item in
            if item != nil {
                draft.photoAssetName = "room_photo_1"
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }
}
