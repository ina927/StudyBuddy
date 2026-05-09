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
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
 
                // Instruction
                Text("Move the pin to your exact location.")
                    .font(AppTheme.Typography.bodySmall)
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
 
                // ── Floor sidebar + map ───────────────────────────────────
                HStack(spacing: 0) {
 
                    // Floor sidebar
                    ScrollView {
                        VStack(spacing: AppTheme.Spacing.xs) {
                            ForEach(sameBuildingFloors, id: \.self) { floor in
                                Button(floor.replacingOccurrences(of: "Level ", with: "L")) {
                                    draft.floor = floor
                                    // ── 층 바꿀 때 지도 이미지도 업데이트 ──
                                    if let building = MetadataStore.buildings.first(where: { $0.code == draft.buildingCode }),
                                       let floorData = building.floors.first(where: { $0.name == floor }) {
                                        draft.floorPlanAssetName = floorData.floorPlanAssetName
                                    }
                                }
                                .font(AppTheme.Typography.labelSmall)
                                .foregroundStyle(
                                    draft.floor == floor ? .white : AppTheme.Colors.primary
                                )
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, AppTheme.Spacing.xs)
                                .background(
                                    draft.floor == floor
                                        ? AppTheme.Colors.primary
                                        : AppTheme.Colors.primaryPale
                                )
                                .cornerRadius(AppTheme.Radius.sm)
                                .padding(.horizontal, AppTheme.Spacing.xxs)
                            }
                        }
                        .padding(.vertical, AppTheme.Spacing.sm)
                    }
                    .frame(width: 52)
                    .background(AppTheme.Colors.inputBg)
 
                    // Floor plan map + draggable pin
                    ZStack {
                        AppTheme.Colors.primaryPale.opacity(0.4)
 
                        Image(draft.floorPlanAssetName)
                            .resizable()
                            .scaledToFit()
 
                        GeometryReader { geo in
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundStyle(AppTheme.Colors.locationText)
                                .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
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
                .shadow(color: AppTheme.Shadows.subtle.color,
                        radius: AppTheme.Shadows.subtle.radius,
                        x: AppTheme.Shadows.subtle.x,
                        y: AppTheme.Shadows.subtle.y)
 
                // ── Location Description ──────────────────────────────────
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
                    .background(AppTheme.Colors.inputBg)
                    .cornerRadius(AppTheme.Radius.lg)
                }
 
                // ── Location Photo ────────────────────────────────────────
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
                                Image(systemName: draft.photoAssetName == nil
                                      ? "camera.fill" : "checkmark.circle.fill")
                                    .font(.system(size: 22))
                                    .foregroundStyle(AppTheme.Colors.primary)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text(draft.photoAssetName == nil
                                     ? "Tap to add a photo"
                                     : "Photo selected ✓")
                                    .font(AppTheme.Typography.label)
                                    .foregroundStyle(AppTheme.Colors.primary)
                                Text(draft.photoAssetName == nil
                                     ? "Show us where you're sitting"
                                     : "Tap to change photo")
                                    .font(AppTheme.Typography.bodySmall)
                                    .foregroundStyle(AppTheme.Colors.textTertiary)
                            }
                            Spacer()
                        }
                        .padding(AppTheme.Spacing.sm)
                        .background(AppTheme.Colors.inputBg)
                        .cornerRadius(AppTheme.Radius.lg)
                    }
                }
 
                // ── Next button ───────────────────────────────────────────
                Button { onNext() } label: {
                    Text("Next")
                        .font(AppTheme.Typography.label.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.sm)
                        .background(
                            draft.canProceedFromLocation
                                ? AppTheme.Colors.primary
                                : AppTheme.Colors.textTertiary
                        )
                        .cornerRadius(AppTheme.Radius.pill)
                }
                .disabled(!draft.canProceedFromLocation)
                .padding(.top, AppTheme.Spacing.xs)
            }
            .padding(AppTheme.Spacing.md)
        }
        .background(AppTheme.Colors.background)
        .onChange(of: photoItem) {
            if photoItem != nil {
                draft.photoAssetName = "room_photo_1"
            }
        }
    }
}
