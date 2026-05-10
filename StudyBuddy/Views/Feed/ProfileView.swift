//
//  ProfileView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject private var appState: AppState
    @State private var isEditing = false
    @State private var profileImage: UIImage? = nil
    @State private var showPhotoOptions = false
    @State private var showCamera = false
    @State private var showLibrary = false

    enum ProfileTab { case profile, posts }
    @State private var profileTab: ProfileTab = .profile

    private let headerPurple = AppTheme.Colors.primary

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    tabPickerSection
                    switch profileTab {
                    case .profile: profileInfoSection
                    case .posts: myPostsSection
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppTheme.Colors.background)
            .background(headerPurple, ignoresSafeAreaEdges: .top)
            .sheet(isPresented: $isEditing) {
                EditProfileView()
            }
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
        ZStack(alignment: .bottomTrailing) {
            Group {
                if let pic = appState.currentUser?.profilePic,
                   let url = URL(string: pic) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        default:
                            Circle()
                                .fill(AppTheme.Colors.primaryPale)
                                .overlay(
                                    Text(initials)
                                        .font(.title.weight(.bold))
                                        .foregroundStyle(AppTheme.Colors.primary)
                                )
                        }
                    }
                } else {
                    Circle()
                        .fill(AppTheme.Colors.primaryPale)
                        .overlay(
                            Text(initials)
                                .font(.title.weight(.bold))
                                .foregroundStyle(AppTheme.Colors.primary)
                        )
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())

            Button {
                showPhotoOptions = true
            } label: {
                Circle()
                    .fill(AppTheme.Colors.accent)
                    .frame(width: 28, height: 28)
                    .overlay(
                        Image(systemName: "camera.fill")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white)
                    )
            }
            .offset(x: 2, y: 2)
        }
        .confirmationDialog("Update profile photo", isPresented: $showPhotoOptions, titleVisibility: .visible) {
            Button("Take a photo") { showCamera = true }
            Button("Choose from library") { showLibrary = true }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showCamera) {
            CameraView(image: $profileImage, sourceType: .camera)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showLibrary) {
            CameraView(image: $profileImage, sourceType: .photoLibrary)
                .ignoresSafeArea()
        }
        .onChange(of: profileImage) {
            guard let image = profileImage, let user = appState.currentUser else { return }
            Task {
                if let url = await appState.uploadImage(image, identifier: user.id, folder: "profile") {
                    var updated = user
                    updated.profilePic = url
                    appState.saveUser(updated)
                    await MainActor.run {
                        appState.currentUser = updated
                    }
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
        if let degree = user.degrees.first {
            parts.append(degree)
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
                    .foregroundStyle(profileTab == tab ? AppTheme.Colors.primary : Color.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                Rectangle()
                    .fill(profileTab == tab ? AppTheme.Colors.primary : Color.clear)
                    .frame(height: 2)
            }
        }
        .buttonStyle(.plain)
    }

    private var profileInfoSection: some View {
        VStack(spacing: 12) {
            if let user = appState.currentUser {
                infoRow(label: "Degree", value: user.degrees.first ?? "-")
                infoRow(label: "Major", value: user.major ?? "-")
                infoRow(label: "Year", value: user.year.isEmpty ? "-" : user.year)
                infoRow(label: "University", value: "University of Technology Sydney")
                infoRow(label: "Email", value: user.email)
            }

            Button(role: .destructive) {
                appState.logout()
            } label: {
                Text("Log out")
                    .font(AppTheme.Typography.bodyMedium.weight(.semibold))
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.sm)
                    .background(AppTheme.Colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
            }
            .buttonStyle(.plain)
        }
        .padding(16)
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(AppTheme.Typography.bodySmall)
                .foregroundStyle(AppTheme.Colors.textSecondary)
                .frame(width: 80, alignment: .leading)
            Spacer()
            Text(value)
                .font(AppTheme.Typography.bodyMedium)
                .foregroundStyle(AppTheme.Colors.textPrimary)
                .lineLimit(1)
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.vertical, AppTheme.Spacing.sm)
        .background(AppTheme.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
    }

    private var myPostsSection: some View {
        guard let user = appState.currentUser else { return AnyView(EmptyView()) }

        let activeIndices = appState.posts.indices.filter {
            appState.posts[$0].hostUserID == user.id &&
            appState.posts[$0].computedStatus != .finished
        }
        let pastIndices = appState.posts.indices.filter {
            appState.posts[$0].hostUserID == user.id &&
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
                            .foregroundStyle(AppTheme.Colors.primary)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)

                ForEach(activeIndices, id: \.self) { idx in
                    NavigationLink {
                        PostDetailView(post: appState.posts[idx])
                    } label: {
                        MyPostCard(post: $appState.posts[idx])
                    }
                    .buttonStyle(.plain)
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
                        NavigationLink {
                            PostDetailView(post: appState.posts[idx])
                        } label: {
                            MyPostCard(post: $appState.posts[idx], isPast: true)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)
                    }
                }
            }
            .padding(.top, 4)
        )
    }
}
