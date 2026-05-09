//
//  BuildingDirectoryView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI

struct BuildingDirectoryView: View {
    let autoExpandBuildingID: String?
    let onSelectFloor: (_ code: String, _ name: String, _ floor: String, _ asset: String) -> Void

    @State private var expanded: Set<String> = []
    @State private var searchQuery = ""

    private var filteredBuildings: [BuildingOption] {
        if searchQuery.isEmpty { return MetadataStore.buildings }
        return MetadataStore.buildings.filter { $0.label.localizedCaseInsensitiveContains(searchQuery) }
    }

    var body: some View {
        ZStack {
            AppTheme.Colors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack(spacing: AppTheme.Spacing.xs) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(AppTheme.Colors.textTertiary)
                        .font(.system(size: 15))
                    TextField("Search building...", text: $searchQuery)
                        .font(AppTheme.Typography.bodyMedium)
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.vertical, AppTheme.Spacing.sm)
                .background(AppTheme.Colors.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.Radius.pill)
                        .stroke(AppTheme.Colors.primary, lineWidth: 1)
                )
                .cornerRadius(AppTheme.Radius.pill)
                .padding(AppTheme.Spacing.md)

                ScrollView {
                    VStack(spacing: AppTheme.Spacing.sm) {
                        ForEach(filteredBuildings) { b in
                            VStack(spacing: 0) {
                                Button {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if expanded.contains(b.id) {
                                            expanded.remove(b.id)
                                        } else {
                                            expanded.insert(b.id)
                                        }
                                    }
                                } label: {
                                    HStack(spacing: AppTheme.Spacing.sm) {
                                        ZStack {
                                            Circle()
                                                .fill(AppTheme.Colors.primaryPale)
                                                .frame(width: 36, height: 36)
                                            Image(systemName: "building.2")
                                                .font(.system(size: 15))
                                                .foregroundStyle(AppTheme.Colors.primary)
                                        }

                                        Text(b.label)
                                            .font(AppTheme.Typography.bodyMedium)
                                            .foregroundStyle(AppTheme.Colors.textPrimary)

                                        Spacer()

                                        Image(systemName: expanded.contains(b.id) ? "chevron.up" : "chevron.down")
                                            .font(.system(size: 12))
                                            .foregroundStyle(AppTheme.Colors.textTertiary)
                                    }
                                    .padding(.horizontal, AppTheme.Spacing.md)
                                    .padding(.vertical, AppTheme.Spacing.sm)
                                    .background(AppTheme.Colors.surface)
                                }
                                .buttonStyle(.plain)

                                if expanded.contains(b.id) {
                                    VStack(spacing: 0) {
                                        Divider()
                                            .background(AppTheme.Colors.divider)
                                            .padding(.horizontal, AppTheme.Spacing.md)

                                        ForEach(b.floors) { floor in
                                            Button {
                                                onSelectFloor(b.code, b.name, floor.name, floor.floorPlanAssetName)
                                            } label: {
                                                HStack(spacing: AppTheme.Spacing.sm) {
                                                    Image(systemName: "square.split.bottomrightquarter")
                                                        .font(.system(size: 13))
                                                        .foregroundStyle(AppTheme.Colors.primaryLight)
                                                        .frame(width: 36)

                                                    Text(floor.name)
                                                        .font(AppTheme.Typography.bodyMedium)
                                                        .foregroundStyle(AppTheme.Colors.textSecondary)

                                                    Spacer()

                                                    Image(systemName: "chevron.right")
                                                        .font(.system(size: 11))
                                                        .foregroundStyle(AppTheme.Colors.textTertiary)
                                                }
                                                .padding(.horizontal, AppTheme.Spacing.md)
                                                .padding(.vertical, AppTheme.Spacing.sm)
                                                .background(AppTheme.Colors.surface)
                                                .contentShape(Rectangle())
                                            }
                                            .buttonStyle(.plain)

                                            if floor.id != b.floors.last?.id {
                                                Divider()
                                                    .background(AppTheme.Colors.divider)
                                                    .padding(.leading, AppTheme.Spacing.md + 36 + AppTheme.Spacing.sm)
                                            }
                                        }
                                    }
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
                            .shadow(color: AppTheme.Shadows.subtle.color,
                                    radius: AppTheme.Shadows.subtle.radius,
                                    x: AppTheme.Shadows.subtle.x,
                                    y: AppTheme.Shadows.subtle.y)
                        }
                    }
                    .padding(AppTheme.Spacing.md)
                }
            }
        }
        .onChange(of: autoExpandBuildingID) { _, newValue in
            guard let id = newValue else { return }
            _ = withAnimation {
                expanded.insert(id)
            }
        }
    }
}
