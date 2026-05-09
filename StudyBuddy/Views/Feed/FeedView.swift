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
    @State private var showFilterSheet = false
 
    @State private var selectedBuilding = "All"
    @State private var selectedVibe = ""
    @State private var showAllStatus = false
    @State private var degree = "All"
    @State private var timePreset = "Now"
    @State private var customFrom = Date()
    @State private var customTo = Date().addingTimeInterval(7200)
 
    private var activeFilterCount: Int {
        [selectedBuilding != "All",
         !selectedVibe.isEmpty,
         timePreset != "Now",
         degree != "All"].filter { $0 }.count
    }
 
    // Active filter labels to show as chips
    private var activeFilterChips: [(id: String, label: String)] {
        var chips: [(String, String)] = []
        if degree != "All"        { chips.append(("degree", degree)) }
        if !selectedVibe.isEmpty  { chips.append(("vibe", selectedVibe)) }
        if showAllStatus          { chips.append(("availability", "All availability")) }
        if selectedBuilding != "All" { chips.append(("building", selectedBuilding)) }
        if timePreset != "Now"    { chips.append(("time", timePreset)) }
        return chips
    }
 
    private var filtered: [StudyPost] {
        let now = Date()
        return appState.posts.filter { post in
            let statusPass = showAllStatus ? true : post.computedStatus == .ongoing
            let buildingPass = selectedBuilding == "All" || post.buildingCode == selectedBuilding
            let vibePass = selectedVibe.isEmpty || post.vibe == selectedVibe
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
            let queryPass = query.isEmpty
                || post.title.localizedCaseInsensitiveContains(query)
                || post.bodyText.localizedCaseInsensitiveContains(query)
            return statusPass && buildingPass && vibePass && timePass && degreePass && queryPass
        }
        .sorted { $0.createdAt > $1.createdAt }
    }
 
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()
 
                VStack(spacing: 0) {
 
                    // ── Header ────────────────────────────────────────────
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
 
                        // Title
                        Text("StudyBuddy")
                            .font(AppTheme.Typography.appTitle)
                            .foregroundStyle(AppTheme.Colors.textPrimary)
                            .padding(.horizontal, AppTheme.Spacing.md)
                            .padding(.top, AppTheme.Spacing.md)
 
                        // Search bar — lavender pill
                        HStack(spacing: AppTheme.Spacing.xs) {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(AppTheme.Colors.textTertiary)
                                .font(.system(size: 15))
                            TextField("Search posts...", text: $query)
                                .font(AppTheme.Typography.bodyMedium)
                                .foregroundStyle(AppTheme.Colors.textPrimary)
                        }
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .padding(.vertical, AppTheme.Spacing.sm)
                        .background(AppTheme.Colors.primaryPale)
                        .cornerRadius(AppTheme.Radius.pill)
                        .padding(.horizontal, AppTheme.Spacing.md)
 
                        // Filter chips row
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppTheme.Spacing.xs) {
 
                                // Purple Filters button with badge
                                Button { showFilterSheet = true } label: {
                                    HStack(spacing: AppTheme.Spacing.xxs) {
                                        Image(systemName: "slider.horizontal.3")
                                            .font(.system(size: 12))
                                        Text("Filters")
                                            .font(AppTheme.Typography.label)
                                        if activeFilterCount > 0 {
                                            Text("\(activeFilterCount)")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundStyle(.white)
                                                .frame(width: 16, height: 16)
                                                .background(AppTheme.Colors.accent)
                                                .clipShape(Circle())
                                        }
                                    }
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, AppTheme.Spacing.sm)
                                    .padding(.vertical, AppTheme.Spacing.xs)
                                    .background(AppTheme.Colors.primary)
                                    .cornerRadius(AppTheme.Radius.pill)
                                }
 
                                // ── Only show chips for ACTIVE filters ────
                                ForEach(activeFilterChips, id: \.id) { chip in
                                    ActiveFilterChip(label: chip.label) {
                                        removeFilter(id: chip.id)
                                    }
                                }
                            }
                            .padding(.horizontal, AppTheme.Spacing.md)
                            .padding(.bottom, AppTheme.Spacing.sm)
                        }
                    }
                    .background(AppTheme.Colors.background)
 
                    // ── Posts list ────────────────────────────────────────
                    if filtered.isEmpty {
                        Spacer()
                        VStack(spacing: AppTheme.Spacing.sm) {
                            Image(systemName: "person.2")
                                .font(.system(size: 40))
                                .foregroundStyle(AppTheme.Colors.textTertiary)
                            Text("No study sessions found.")
                                .font(AppTheme.Typography.bodyMedium)
                                .foregroundStyle(AppTheme.Colors.textSecondary)
                            Text("Try adjusting your filters.")
                                .font(AppTheme.Typography.bodySmall)
                                .foregroundStyle(AppTheme.Colors.textTertiary)
                        }
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: AppTheme.Spacing.md) {
                                ForEach(filtered) { post in
                                    NavigationLink {
                                        PostDetailView(post: post)
                                    } label: {
                                        PostCardView(post: post)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, AppTheme.Spacing.md)
                            .padding(.vertical, AppTheme.Spacing.sm)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showFilterSheet) {
                FilterSheetView(
                    selectedBuilding: $selectedBuilding,
                    selectedVibe: $selectedVibe,
                    showAllStatus: $showAllStatus,
                    degree: $degree,
                    timePreset: $timePreset,
                    customFrom: $customFrom,
                    customTo: $customTo
                )
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
        }
    }
 
    private func removeFilter(id: String) {
        switch id {
        case "degree":       degree = "All"
        case "vibe":         selectedVibe = ""
        case "availability": showAllStatus = false
        case "building":     selectedBuilding = "All"
        case "time":         timePreset = "Now"
        default: break
        }
    }
}
 
// MARK: - Active filter chip (coral, with × to remove)
struct ActiveFilterChip: View {
    let label: String
    let onRemove: () -> Void
 
    var body: some View {
        HStack(spacing: 4) {
            Text(label)
                .font(AppTheme.Typography.label)
                .foregroundStyle(AppTheme.Colors.accent)
                .lineLimit(1)
 
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(AppTheme.Colors.accent)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.sm)
        .padding(.vertical, AppTheme.Spacing.xs)
        .background(AppTheme.Colors.accentLight)
        .cornerRadius(AppTheme.Radius.pill)
        .overlay(
            Capsule()
                .stroke(AppTheme.Colors.accent, lineWidth: 1.2)
        )
    }
}
 
// MARK: - Filter Bottom Sheet
struct FilterSheetView: View {
    @Environment(\.dismiss) private var dismiss
 
    @Binding var selectedBuilding: String
    @Binding var selectedVibe: String
    @Binding var showAllStatus: Bool
    @Binding var degree: String
    @Binding var timePreset: String
    @Binding var customFrom: Date
    @Binding var customTo: Date
 
    @State private var locationQuery = ""
 
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()
 
                ScrollView {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
 
                        // Location
                        FilterSection(title: "Location") {
                            HStack(spacing: AppTheme.Spacing.xs) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(AppTheme.Colors.textTertiary)
                                TextField("Search location...", text: $locationQuery)
                                    .font(AppTheme.Typography.bodyMedium)
                            }
                            .padding(AppTheme.Spacing.sm)
                            .background(AppTheme.Colors.inputBg)
                            .cornerRadius(AppTheme.Radius.md)
                        }
 
                        // Faculty
                        FilterSection(title: "Faculty") {
                            Menu {
                                Button("All") { degree = "All" }
                                ForEach(MetadataStore.degrees.map(\.title), id: \.self) { d in
                                    Button(d) { degree = d }
                                }
                            } label: {
                                HStack {
                                    Text(degree == "All" ? "Select faculty..." : degree)
                                        .font(AppTheme.Typography.bodyMedium)
                                        .foregroundStyle(degree == "All"
                                            ? AppTheme.Colors.textTertiary
                                            : AppTheme.Colors.textPrimary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 12))
                                        .foregroundStyle(AppTheme.Colors.textTertiary)
                                }
                                .padding(AppTheme.Spacing.sm)
                                .background(AppTheme.Colors.inputBg)
                                .cornerRadius(AppTheme.Radius.md)
                            }
                        }
 
                        // Vibe chips
                        FilterSection(title: "Vibe") {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: AppTheme.Spacing.xs) {
                                    ForEach(MetadataStore.vibes, id: \.self) { vibe in
                                        Button {
                                            selectedVibe = selectedVibe == vibe ? "" : vibe
                                        } label: {
                                            Text(vibe).vibeChip(isSelected: selectedVibe == vibe)
                                        }
                                    }
                                }
                            }
                        }
 
                        // Time
                        FilterSection(title: "Time") {
                            Picker("", selection: $timePreset) {
                                Text("Now").tag("Now")
                                Text("Next 2h").tag("Next 2h")
                                Text("Custom").tag("Custom")
                            }
                            .pickerStyle(.segmented)
 
                            if timePreset == "Custom" {
                                DatePicker("From", selection: $customFrom)
                                DatePicker("To", selection: $customTo)
                            }
                        }
 
                        // Spots available
                        FilterSection(title: "Spots available") {
                            Toggle("Show all (including full)", isOn: $showAllStatus)
                                .tint(AppTheme.Colors.primary)
                                .font(AppTheme.Typography.bodyMedium)
                        }
                    }
                    .padding(AppTheme.Spacing.md)
                }
            }
            .navigationTitle("Filter posts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Clear All") {
                        selectedBuilding = "All"
                        selectedVibe = ""
                        showAllStatus = false
                        degree = "All"
                        timePreset = "Now"
                    }
                    .foregroundStyle(AppTheme.Colors.accent)
                    .font(AppTheme.Typography.label)
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button { dismiss() } label: {
                    Text("Show results")
                        .font(AppTheme.Typography.label)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.sm)
                        .background(AppTheme.Colors.primary)
                        .cornerRadius(AppTheme.Radius.pill)
                }
                .padding(AppTheme.Spacing.md)
                .background(AppTheme.Colors.background)
            }
        }
    }
}
 
// MARK: - Filter Section wrapper
struct FilterSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
 
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            Text(title)
                .font(AppTheme.Typography.label)
                .foregroundStyle(AppTheme.Colors.primary)
            content
        }
    }
}
