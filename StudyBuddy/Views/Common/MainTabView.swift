//
//  MainTabView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI
import PhotosUI

struct MainTabView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            FeedView()
                .tabItem { Label("Feed", systemImage: "list.bullet.rectangle") }
                .tag(0)

            CreatePostRootView()
                .tabItem { Label("Create", systemImage: "plus.circle") }
                .tag(1)

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
                .tag(3)
        }
        .tint(Color(red: 0.427, green: 0.337, blue: 0.910))
    }
}

struct ProfileView: View {
    @EnvironmentObject private var appState: AppState
    @State private var isEditing = false

    enum ProfileTab { case profile, posts }
    @State private var profileTab: ProfileTab = .profile

    @State private var avatarItem: PhotosPickerItem? = nil

    private let headerPurple = Color(red: 0.608, green: 0.475, blue: 0.929)

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerSection
                tabPickerSection
                switch profileTab {
                case .profile: profileInfoSection
                case .posts:   myPostsSection
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.pageBg)
        .background(headerPurple, ignoresSafeAreaEdges: .top)
        .sheet(isPresented: $isEditing) {
            EditProfileView()
        }
    }

    private var headerSection: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 8) {
                Spacer().frame(height: 14)
                avatarBadge
                if let user = appState.currentUser {
                    Text(user.username)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                    Text(subtitleText(for: user))
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.85))
                }
                Spacer().frame(height: 20)
            }
            .frame(maxWidth: .infinity)

            Button("Edit") { isEditing = true }
                .foregroundStyle(.white)
                .font(.body.weight(.medium))
                .padding(.top, 14)
                .padding(.trailing, 20)
        }
        .background(headerPurple)
    }

    private var avatarBadge: some View {
        PhotosPicker(selection: $avatarItem, matching: .images) {
            ZStack(alignment: .bottomTrailing) {
                Group {
                    if let data = appState.currentUser?.avatarData,
                       let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Circle()
                            .fill(AppTheme.softPurple)
                            .overlay(
                                Text(initials)
                                    .font(.title.weight(.bold))
                                    .foregroundStyle(AppTheme.accentPurple)
                            )
                    }
                }
                .frame(width: 80, height: 80)
                .clipShape(Circle())

                Circle()
                    .fill(Color(red: 0.933, green: 0.369, blue: 0.408))
                    .frame(width: 28, height: 28)
                    .overlay(
                        Image(systemName: "pencil")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white)
                    )
                    .offset(x: 2, y: 2)
            }
        }
        .onChange(of: avatarItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    guard var user = appState.currentUser else { return }
                    user.avatarData = data
                    appState.currentUser = user
                }
            }
        }
    }

    private var initials: String {
        guard let user = appState.currentUser else { return "" }
        let f = user.firstName.first.map(String.init) ?? String(user.username.prefix(1))
        let l = user.lastName.first.map(String.init) ?? String(user.username.dropFirst().prefix(1))
        return (f + l).uppercased()
    }

    private func subtitleText(for user: UserProfile) -> String {
        var parts: [String] = []
        if let major = user.major, !major.isEmpty { parts.append(major) }
        if let degree = user.degrees.first {
            parts.append(degree.components(separatedBy: " ").last ?? degree)
        }
        if !user.year.isEmpty { parts.append(user.year) }
        return parts.joined(separator: ", ")
    }

    private var tabPickerSection: some View {
        HStack(spacing: 0) {
            tabButton("Profile", tab: .profile)
            tabButton("My posts", tab: .posts)
        }
        .background(Color.white)
    }

    private func tabButton(_ title: String, tab: ProfileTab) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.18)) { profileTab = tab }
        } label: {
            VStack(spacing: 0) {
                Text(title)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(profileTab == tab ? AppTheme.accentPurple : Color.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                Rectangle()
                    .fill(profileTab == tab ? AppTheme.accentPurple : Color.clear)
                    .frame(height: 2)
            }
        }
        .buttonStyle(.plain)
    }

    private var profileInfoSection: some View {
        VStack(spacing: 12) {
            if let user = appState.currentUser {
                infoRow(label: "Faculty",    value: user.degrees.first ?? "-")
                infoRow(label: "Major",      value: user.major ?? "-")
                infoRow(label: "Year",       value: user.year.isEmpty ? "-" : user.year)
                infoRow(label: "University", value: "University of Technology Sydney")
                infoRow(label: "Email",      value: user.email)
            }

            Button(role: .destructive) {
                appState.logout()
            } label: {
                Text("Log out")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.red.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(16)
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(Color.secondary)
                .frame(width: 80, alignment: .leading)
            Spacer()
            Text(value)
                .font(.subheadline.weight(.semibold))
                .lineLimit(1)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(AppTheme.softPurple)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var myPostsSection: some View {
        guard let user = appState.currentUser else { return AnyView(EmptyView()) }

        let activeIndices = appState.posts.indices.filter {
            appState.posts[$0].hostUsername == user.username &&
            appState.posts[$0].computedStatus != .finished
        }
        let pastIndices = appState.posts.indices.filter {
            appState.posts[$0].hostUsername == user.username &&
            appState.posts[$0].computedStatus == .finished
        }

        return AnyView(
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("\(activeIndices.count) active post\(activeIndices.count == 1 ? "" : "s")")
                        .font(.subheadline)
                        .foregroundStyle(Color.secondary)
                    Spacer()
                    Button {
                        appState.selectedTab = 1
                    } label: {
                        Text("+ New post")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(AppTheme.accentPurple)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)

                ForEach(activeIndices, id: \.self) { idx in
                    MyPostCard(post: $appState.posts[idx])
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)
                }

                if !pastIndices.isEmpty {
                    Divider().padding(.horizontal, 16).padding(.vertical, 4)

                    Text("Past posts")
                        .font(.subheadline)
                        .foregroundStyle(Color.secondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)

                    ForEach(pastIndices, id: \.self) { idx in
                        MyPostCard(post: $appState.posts[idx], isPast: true)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 12)
                    }
                }
            }
            .padding(.top, 4)
        )
    }
}

private struct MyPostCard: View {
    @EnvironmentObject private var appState: AppState
    @Binding var post: StudyPost
    var isPast: Bool = false
    @State private var showingEdit = false
    private let headerPurple = Color(red: 0.608, green: 0.475, blue: 0.929)

    var body: some View {
        HStack(spacing: 0) {
            imagePlaceholder
            infoSection
        }
        .frame(height: 92)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.07), radius: 4, x: 0, y: 2)
        .sheet(isPresented: $showingEdit) {
            PostStatusEditSheet(post: $post)
        }
    }

    private var imagePlaceholder: some View {
        ZStack {
            headerPurple.opacity(isPast ? 0.55 : 0.85)
            if let assetName = post.photoAssetName {
                Image(assetName)
                    .resizable()
                    .scaledToFill()
                    .opacity(isPast ? 0.6 : 1)
            } else {
                Image(systemName: "camera")
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.75))
            }
        }
        .frame(width: 92)
        .clipped()
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(post.title)
                .font(.subheadline.weight(.bold))
                .lineLimit(1)
                .foregroundStyle(isPast ? Color.secondary : Color.primary)

            Label("\(post.buildingCode).\(post.floor)", systemImage: "mappin.fill")
                .font(.caption)
                .foregroundStyle(Color.secondary)

            if !isPast {
                Text(timeRangeText)
                    .font(.caption)
                    .foregroundStyle(Color.secondary)

                HStack {
                    PostStatusBadge(status: post.computedStatus)
                    Spacer()
                    Button("Edit") { showingEdit = true }
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(AppTheme.accentPurple)
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var timeRangeText: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "h:mma"
        let start = fmt.string(from: post.startTime).lowercased()
        let end   = fmt.string(from: post.endTime).lowercased()
        let isToday = Calendar.current.isDateInToday(post.startTime)
        if isToday { return "\(start) - \(end) today" }
        let dayFmt = DateFormatter()
        dayFmt.dateFormat = "MMM d"
        return "\(start) - \(end), \(dayFmt.string(from: post.startTime))"
    }
}

private struct EditProfileView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss

    @State private var firstName = ""
    @State private var lastName  = ""
    @State private var username  = ""
    @State private var year      = "Year 1"
    @State private var major     = ""
    @State private var degrees: [String] = []

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.pageBg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Name", systemImage: "person")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            HStack(spacing: 12) {
                                AuthInputField(icon: "person", placeholder: "First name", text: $firstName)
                                AuthInputField(icon: "person", placeholder: "Last name",  text: $lastName)
                            }
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Label("Username", systemImage: "at")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            AuthInputField(icon: "at", placeholder: "Username", text: $username)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Label("Faculty / Degree", systemImage: "graduationcap")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            MultiSelectDropdown(
                                placeholder: "Search degree",
                                options: MetadataStore.degrees.map(\.title),
                                selectedItems: $degrees,
                                maxSelection: 4
                            )
                        }

                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Year", systemImage: "calendar")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Picker("Year", selection: $year) {
                                    ForEach(["Year 1", "Year 2", "Year 3", "Year 4+"], id: \.self) { Text($0) }
                                }
                                .pickerStyle(.menu)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 13)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(AppTheme.softPurple)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Label("Major", systemImage: "book")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                AuthInputField(icon: "book.closed", placeholder: "Optional", text: $major)
                            }
                        }

                        Button {
                            guard var user = appState.currentUser else { return }
                            user.firstName = firstName
                            user.lastName  = lastName
                            user.username  = username.isEmpty ? user.username : username
                            user.year      = year
                            user.major     = major.isEmpty ? nil : major
                            user.degrees   = degrees
                            appState.currentUser = user
                            appState.saveUser(user)
                            dismiss()
                        } label: {
                            Text("Save")
                                .font(.body.weight(.semibold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 17)
                                .background(AppTheme.accentPurple)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                guard let user = appState.currentUser else { return }
                firstName = user.firstName
                lastName  = user.lastName
                username  = user.username
                year      = user.year.isEmpty ? "Year 1" : user.year
                major     = user.major ?? ""
                degrees   = user.degrees
            }
        }
    }
}

private struct PostStatusEditSheet: View {
    @EnvironmentObject private var appState: AppState
    @Binding var post: StudyPost
    @Environment(\.dismiss) private var dismiss
    @State private var selected: StudyPost.Status = .notStarted

    var body: some View {
        NavigationStack {
            List {
                ForEach(StudyPost.Status.allCases, id: \.self) { status in
                    Button {
                        selected = status
                    } label: {
                        HStack {
                            PostStatusBadge(status: status)
                            Spacer()
                            if selected == status {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(AppTheme.accentPurple)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle("Update Status")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        post.statusOverride = selected
                        appState.updatePost(post)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                selected = post.statusOverride ?? post.computedStatus
            }
        }
    }
}
