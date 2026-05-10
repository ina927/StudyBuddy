//
//  FeedView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var appState: AppState

    @State private var query = ""
    @State private var showFilterSheet = false

    @State private var selectedStatuses: Set<StudyPost.Status> = [.ongoing, .notStarted]
    @State private var selectedDegrees: [String] = []
    @State private var selectedSubjects: [String] = []
    @State private var selectedBuildings: Set<String> = []

    @State private var showAllBuildings = true
    @State private var showAllTime = true

    @State private var selectedDate = Calendar.current.startOfDay(for: Date())
    @State private var fromMinute = Calendar.current.component(.hour, from: Date()) * 60 + Calendar.current.component(.minute, from: Date())
    @State private var toMinute = 1439

    private var fromDate: Date {
        Calendar.current.date(byAdding: .minute, value: fromMinute, to: selectedDate) ?? selectedDate
    }

    private var toDate: Date {
        Calendar.current.date(byAdding: .minute, value: toMinute, to: selectedDate) ?? selectedDate
    }

    private var activeFilterTokens: [FilterToken] {
        var tokens: [FilterToken] = []

        for s in selectedStatuses.sorted(by: { $0.rawValue < $1.rawValue }) {
            tokens.append(.init(label: s.rawValue, type: .status(s)))
        }

        for d in selectedDegrees {
            tokens.append(.init(label: d, type: .degree(d)))
        }

        for s in selectedSubjects {
            tokens.append(.init(label: s, type: .subject(s)))
        }

        if !showAllBuildings {
            for b in selectedBuildings.sorted() {
                tokens.append(.init(label: b, type: .building(b)))
            }
        }

        if !showAllTime {
            tokens.append(.init(label: selectedDate.formatted(date: .abbreviated, time: .omitted), type: .date))
        }
        
        return tokens
    }

    private var filtered: [StudyPost] {
        appState.posts.filter { post in
            let statusPass = selectedStatuses.contains(post.computedStatus)
            let degreePass = selectedDegrees.isEmpty || !Set(post.hostDegrees).isDisjoint(with: Set(selectedDegrees))
            let subjectPass = selectedSubjects.isEmpty || !Set(post.subjects).isDisjoint(with: Set(selectedSubjects))
            let buildingPass = showAllBuildings || selectedBuildings.contains(post.buildingCode)
            let timePass = showAllTime || (post.startTime <= toDate && post.endTime >= fromDate)

            let q = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let queryPass = q.isEmpty
                || post.title.lowercased().contains(q)
                || post.bodyText.lowercased().contains(q)
                || post.hostUsername.lowercased().contains(q)
                || post.subjects.joined(separator: " ").lowercased().contains(q)

            return statusPass && degreePass && subjectPass && buildingPass && timePass && queryPass
        }
        .sorted { $0.createdAt > $1.createdAt }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text("StudyBuddy")
                            .font(AppTheme.Typography.appTitle)
                            .foregroundStyle(AppTheme.Colors.textPrimary)
                            .padding(.horizontal, AppTheme.Spacing.md)
                            .padding(.top, AppTheme.Spacing.md)

                        HStack(spacing: AppTheme.Spacing.xs) {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(AppTheme.Colors.textTertiary)
                                .font(.system(size: 15))
                            TextField("Search title, description, subject, or host", text: $query)
                                .font(AppTheme.Typography.bodyMedium)
                                .foregroundStyle(AppTheme.Colors.textPrimary)
                        }
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .padding(.vertical, AppTheme.Spacing.sm)
                        .background(AppTheme.Colors.surface)
                        .cornerRadius(AppTheme.Radius.pill)
                        .padding(.horizontal, AppTheme.Spacing.md)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppTheme.Spacing.xs) {
                                Button { showFilterSheet = true } label: {
                                    HStack(spacing: AppTheme.Spacing.xxs) {
                                        Image(systemName: "slider.horizontal.3")
                                        Text("Filters")
                                            .font(AppTheme.Typography.label)
                                        Text("\(activeFilterTokens.count)")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundStyle(.white)
                                            .frame(width: 16, height: 16)
                                            .background(AppTheme.Colors.accent)
                                            .clipShape(Circle())
                                    }
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, AppTheme.Spacing.sm)
                                    .padding(.vertical, AppTheme.Spacing.xs)
                                    .background(AppTheme.Colors.primary)
                                    .cornerRadius(AppTheme.Radius.pill)
                                }

                                ForEach(activeFilterTokens) { token in
                                    HStack(spacing: 6) {
                                        Text(token.label)
                                            .font(AppTheme.Typography.labelSmall)
                                            .foregroundStyle(AppTheme.Colors.primary)
                                        Button {
                                            removeToken(token)
                                        } label: {
                                            Image(systemName: "xmark")
                                                .font(.system(size: 9, weight: .bold))
                                                .foregroundStyle(AppTheme.Colors.primary)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                    .padding(.horizontal, AppTheme.Spacing.sm)
                                    .padding(.vertical, 6)
                                    .background(.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppTheme.Radius.pill)
                                            .stroke(AppTheme.Colors.primary, lineWidth: 1)
                                    )
                                    .clipShape(Capsule())
                                }
                            }
                            .padding(.horizontal, AppTheme.Spacing.md)
                        }
                    }
                    .padding(.bottom, AppTheme.Spacing.sm)

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
                    selectedStatuses: $selectedStatuses,
                    selectedDegrees: $selectedDegrees,
                    selectedSubjects: $selectedSubjects,
                    selectedBuildings: $selectedBuildings,
                    showAllBuildings: $showAllBuildings,
                    showAllTime: $showAllTime,
                    selectedDate: $selectedDate,
                    fromMinute: $fromMinute,
                    toMinute: $toMinute
                )
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .onAppear {
                    if selectedDegrees.isEmpty, let user = appState.currentUser, !user.degrees.isEmpty {
                        selectedDegrees = user.degrees
                    }
                }
            }
        }
    }

    private func removeToken(_ token: FilterToken) {
        switch token.type {
        case .status(let s):
            selectedStatuses.remove(s)
        case .degree(let d):
            selectedDegrees.removeAll { $0 == d }
        case .subject(let s):
            selectedSubjects.removeAll { $0 == s }
        case .building(let b):
            selectedBuildings.remove(b)
        case .date:
            showAllTime = true
            selectedDate = Calendar.current.startOfDay(for: Date())
            fromMinute = Calendar.current.component(.hour, from: Date()) * 60 + Calendar.current.component(.minute, from: Date())
            toMinute = 1439
        }
    }
}

private struct FilterToken: Identifiable {
    enum TokenType {
        case status(StudyPost.Status)
        case degree(String)
        case subject(String)
        case building(String)
        case date
    }

    let id = UUID()
    let label: String
    let type: TokenType
}

struct FilterSheetView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var selectedStatuses: Set<StudyPost.Status>
    @Binding var selectedDegrees: [String]
    @Binding var selectedSubjects: [String]
    @Binding var selectedBuildings: Set<String>
    @Binding var showAllBuildings: Bool
    @Binding var showAllTime: Bool
    @Binding var selectedDate: Date
    @Binding var fromMinute: Int
    @Binding var toMinute: Int

    @State private var buildingTemp: Set<String> = []

    private let buildingColumns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                        FilterSection(title: "Status") {
                            WrapChips(items: StudyPost.Status.allCases.map { $0.rawValue }, selectedItems: Binding(
                                get: { Set(selectedStatuses.map { $0.rawValue }) },
                                set: { rawSet in
                                    let mapped = rawSet.compactMap { StudyPost.Status(rawValue: $0) }
                                    selectedStatuses = Set(mapped)
                                }
                            ))
                        }

                        FilterSection(title: "Vibe") {
                            MultiSelectDropdown(
                                placeholder: "Search vibe",
                                options: MetadataStore.vibes,
                                selectedItems: .constant([]),
                                maxSelection: 1
                            )
                            .opacity(0.6)
                            .allowsHitTesting(false)
                        }

                        FilterSection(title: "Study area") {
                            MultiSelectDropdown(
                                placeholder: "Select degree",
                                options: MetadataStore.degrees.map(\.title),
                                selectedItems: $selectedDegrees,
                                maxSelection: 6
                            )
                        }

                        FilterSection(title: "Subject") {
                            MultiSelectDropdown(
                                placeholder: "Search subject",
                                options: MetadataStore.subjects.map(\.label),
                                selectedItems: $selectedSubjects,
                                maxSelection: 6
                            )
                        }

                        FilterSection(title: "Building") {
                            Button {
                                showAllBuildings.toggle()
                                if showAllBuildings {
                                    buildingTemp.removeAll()
                                }
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: showAllBuildings ? "checkmark.square" : "square")
                                        .font(.system(size: 20))
                                        .foregroundStyle(AppTheme.Colors.primary)
                                    Text("Show all")
                                        .font(AppTheme.Typography.bodyMedium)
                                        .foregroundStyle(AppTheme.Colors.textPrimary)
                                    Spacer()
                                }
                            }
                            .buttonStyle(.plain)

                            if !showAllBuildings {
                                LazyVGrid(columns: buildingColumns, spacing: AppTheme.Spacing.xs) {
                                    ForEach(MetadataStore.buildings.map(\.code), id: \.self) { code in
                                        Button {
                                            if buildingTemp.contains(code) {
                                                buildingTemp.remove(code)
                                            } else {
                                                buildingTemp.insert(code)
                                            }
                                        } label: {
                                            HStack(spacing: 8) {
                                                Image(systemName: buildingTemp.contains(code) ? "checkmark.square" : "square")
                                                    .font(.system(size: 20))
                                                    .foregroundStyle(AppTheme.Colors.primary)
                                                Text(code)
                                                    .font(AppTheme.Typography.bodyMedium)
                                                    .foregroundStyle(AppTheme.Colors.textPrimary)
                                                Spacer()
                                            }
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }

                        FilterSection(title: "Time") {
                            Button {
                                showAllTime.toggle()
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: showAllTime ? "checkmark.square" : "square")
                                        .font(.system(size: 20))
                                        .foregroundStyle(AppTheme.Colors.primary)
                                    Text("Show all")
                                        .font(AppTheme.Typography.bodyMedium)
                                        .foregroundStyle(AppTheme.Colors.textPrimary)
                                    Spacer()
                                }
                            }
                            .buttonStyle(.plain)

                            DatePicker("Date", selection: Binding(
                                get: { selectedDate },
                                set: { newDate in
                                    selectedDate = newDate
                                    showAllTime = false
                                }
                            ), displayedComponents: .date)

                            TimeRangeSlider(
                                fromMinute: Binding(
                                    get: { fromMinute },
                                    set: { newValue in
                                        fromMinute = newValue
                                        showAllTime = false
                                    }
                                ),
                                toMinute: Binding(
                                    get: { toMinute },
                                    set: { newValue in
                                        toMinute = newValue
                                        showAllTime = false
                                    }
                                )
                            )
                        }
                    }
                    .padding(AppTheme.Spacing.md)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Reset") {
                        selectedStatuses = [.ongoing, .notStarted]
                        selectedDegrees = []
                        selectedSubjects = []
                        selectedBuildings = []
                        buildingTemp = []
                        showAllBuildings = true
                        showAllTime = true
                        selectedDate = Calendar.current.startOfDay(for: Date())
                        fromMinute = Calendar.current.component(.hour, from: Date()) * 60 + Calendar.current.component(.minute, from: Date())
                        toMinute = 1439
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Apply") {
                        selectedBuildings = showAllBuildings ? [] : buildingTemp
                        dismiss()
                    }
                }
            }
            .onAppear {
                buildingTemp = selectedBuildings
            }
            .onChange(of: showAllBuildings) { _, value in
                if value { buildingTemp.removeAll() }
            }
        }
    }
}

struct FilterSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text(title)
                .font(AppTheme.Typography.heading2)
                .foregroundStyle(AppTheme.Colors.textPrimary)
            content
        }
    }
}

struct WrapChips: View {
    let items: [String]
    @Binding var selectedItems: Set<String>

    var body: some View {
        let columns = [GridItem(.adaptive(minimum: 120), spacing: AppTheme.Spacing.xs)]
        LazyVGrid(columns: columns, alignment: .leading, spacing: AppTheme.Spacing.xs) {
            ForEach(items, id: \.self) { item in
                Button {
                    if selectedItems.contains(item) {
                        selectedItems.remove(item)
                    } else {
                        selectedItems.insert(item)
                    }
                } label: {
                    Text(item)
                        .font(AppTheme.Typography.label)
                        .foregroundStyle(selectedItems.contains(item) ? .white : AppTheme.Colors.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.xs)
                        .padding(.horizontal, AppTheme.Spacing.sm)
                        .background(selectedItems.contains(item) ? AppTheme.Colors.primary : Color.gray.opacity(0.18))
                        .cornerRadius(AppTheme.Radius.pill)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct TimeRangeSlider: View {
    @Binding var fromMinute: Int
    @Binding var toMinute: Int

    @State private var totalWidth: CGFloat = 300

    private var minX: CGFloat { CGFloat(fromMinute) / 1439 * totalWidth }
    private var maxX: CGFloat { CGFloat(toMinute) / 1439 * totalWidth }
    private var rangeWidth: CGFloat { max(0, maxX - minX) }

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            HStack {
                Text(formattedTime(fromMinute))
                    .font(AppTheme.Typography.heading2)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.18))
                    .clipShape(Capsule())

                Spacer()

                Text(formattedTime(toMinute))
                    .font(AppTheme.Typography.heading2)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.18))
                    .clipShape(Capsule())
            }

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray.opacity(0.35))
                    .frame(height: 8)

                Capsule()
                    .fill(AppTheme.Colors.primary)
                    .frame(width: rangeWidth, height: 8)
                    .offset(x: minX)

                Circle()
                    .fill(AppTheme.Colors.primary)
                    .frame(width: 26, height: 26)
                    .offset(x: minX - 13)
                    .gesture(
                        DragGesture().onChanged { value in
                            let minute = xToMinute(value.location.x)
                            fromMinute = min(max(0, minute), toMinute - 15)
                        }
                    )

                Circle()
                    .fill(AppTheme.Colors.primary)
                    .frame(width: 26, height: 26)
                    .offset(x: maxX - 13)
                    .gesture(
                        DragGesture().onChanged { value in
                            let minute = xToMinute(value.location.x)
                            toMinute = max(minute, fromMinute + 15)
                            toMinute = min(toMinute, 1439)
                        }
                    )
            }
            .frame(height: 32)

            HStack {
                Text("12:00 am")
                    .font(AppTheme.Typography.bodySmall)
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                Spacer()
                Text("11:59 pm")
                    .font(AppTheme.Typography.bodySmall)
                    .foregroundStyle(AppTheme.Colors.textSecondary)
            }
        }
        .background(
            GeometryReader { proxy in
                Color.clear
                    .onAppear { totalWidth = proxy.size.width }
                    .onChange(of: proxy.size.width) { _, value in totalWidth = value }
            }
        )
    }

    private func xToMinute(_ x: CGFloat) -> Int {
        guard totalWidth > 0 else { return 0 }
        let clamped = min(max(0, x), totalWidth)
        return Int((clamped / totalWidth) * 1439)
    }

    private func formattedTime(_ minute: Int) -> String {
        let h = minute / 60
        let m = minute % 60
        let date = Calendar.current.date(bySettingHour: h, minute: m, second: 0, of: Date()) ?? Date()
        return date.formatted(date: .omitted, time: .shortened).lowercased()
    }
}
