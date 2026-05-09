import SwiftUI

struct FeedView: View {
    @EnvironmentObject private var appState: AppState

    @State private var query = ""
    @State private var showFilterSheet = false

    @State private var selectedStatuses: Set<StudyPost.Status> = [.ongoing, .notStarted]
    @State private var selectedDegrees: [String] = []
    @State private var selectedSubjects: [String] = []
    @State private var selectedBuildings: Set<String> = []

    @State private var subjectInput = ""

    @State private var fromDate = Date()
    @State private var toDate = Date().addingTimeInterval(6 * 3600)

    private var activeFilterCount: Int {
        var count = 0
        if selectedStatuses != [.ongoing, .notStarted] { count += 1 }
        if !selectedDegrees.isEmpty { count += 1 }
        if !selectedSubjects.isEmpty { count += 1 }
        if !selectedBuildings.isEmpty { count += 1 }
        if !isDefaultTimeRange { count += 1 }
        return count
    }

    private var isDefaultTimeRange: Bool {
        abs(fromDate.timeIntervalSinceNow) < 120 && abs(toDate.timeIntervalSince(fromDate) - 21600) < 120
    }

    private var filtered: [StudyPost] {
        appState.posts.filter { post in
            let statusPass = selectedStatuses.contains(post.computedStatus)
            let degreePass = selectedDegrees.isEmpty || !Set(post.hostDegrees).isDisjoint(with: Set(selectedDegrees))
            let subjectPass = selectedSubjects.isEmpty || !Set(post.subjects).isDisjoint(with: Set(selectedSubjects))
            let buildingPass = selectedBuildings.isEmpty || selectedBuildings.contains(post.buildingCode)
            let timePass = post.startTime <= toDate && post.endTime >= fromDate

            let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
            let queryPass: Bool
            if q.isEmpty {
                queryPass = true
            } else {
                let lower = q.lowercased()
                queryPass = post.title.lowercased().contains(lower)
                    || post.bodyText.lowercased().contains(lower)
                    || post.hostUsername.lowercased().contains(lower)
                    || post.subjects.joined(separator: " ").lowercased().contains(lower)
            }

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
                        .background(AppTheme.Colors.primaryPale)
                        .cornerRadius(AppTheme.Radius.pill)
                        .padding(.horizontal, AppTheme.Spacing.md)

                        HStack {
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

                            Spacer()
                        }
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .padding(.bottom, AppTheme.Spacing.sm)
                    }

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
                    fromDate: $fromDate,
                    toDate: $toDate,
                    subjectInput: $subjectInput
                )
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .onAppear {
                    if selectedDegrees.isEmpty, let user = appState.currentUser, !user.degrees.isEmpty {
                        selectedDegrees = user.degrees
                    }
                }
            }
        }
    }
}

struct FilterSheetView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var selectedStatuses: Set<StudyPost.Status>
    @Binding var selectedDegrees: [String]
    @Binding var selectedSubjects: [String]
    @Binding var selectedBuildings: Set<String>
    @Binding var fromDate: Date
    @Binding var toDate: Date
    @Binding var subjectInput: String

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
                            WrapChips(items: MetadataStore.buildings.map(\.code), selectedItems: $selectedBuildings)
                        }

                        FilterSection(title: "Time") {
                            DatePicker("From", selection: $fromDate)
                            DatePicker("To", selection: $toDate)
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
                        fromDate = Date()
                        toDate = Date().addingTimeInterval(6 * 3600)
                        subjectInput = ""
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
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
                        .foregroundStyle(selectedItems.contains(item) ? .white : AppTheme.Colors.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.xs)
                        .padding(.horizontal, AppTheme.Spacing.sm)
                        .background(selectedItems.contains(item) ? AppTheme.Colors.primary : AppTheme.Colors.primaryPale)
                        .cornerRadius(AppTheme.Radius.pill)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
