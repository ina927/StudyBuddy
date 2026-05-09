//
//  PostDetailView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI

struct PostDetailView: View {
    @EnvironmentObject private var appState: AppState
    @State var post: StudyPost
    @State private var showEdit = false
    @State private var showFloorMap = false

    @State private var showFullConfirm = false
    @State private var showEndConfirm = false

    private var isHost: Bool {
        appState.currentUser?.id == post.hostUserID
    }

    private var degreeAndYear: String {
        let degree = post.hostDegrees.first ?? "-"
        return "\(degree), \(post.hostYear)"
    }

    private var dateText: String {
        post.startTime.formatted(.dateTime.day().month(.abbreviated).year().weekday(.abbreviated))
    }

    private var timeText: String {
        let start = post.startTime.formatted(date: .omitted, time: .shortened).lowercased()
        let end = post.endTime.formatted(date: .omitted, time: .shortened).lowercased()
        return "\(start) - \(end)"
    }

    private var closingSoon: Bool {
        guard post.computedStatus == .ongoing else { return false }
        return post.endTime.timeIntervalSince(Date()) <= 3600
    }

    private var isFinished: Bool {
        post.computedStatus == .finished
    }

    private var isMarkedFull: Bool {
        post.statusOverride == .full
    }

    var body: some View {
        ZStack {
            AppTheme.Colors.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: AppTheme.Spacing.md) {
                    ZStack(alignment: .bottomLeading) {
                        Rectangle()
                            .fill(AppTheme.Colors.primaryLight.opacity(0.45))
                            .frame(height: 200)

                        if let asset = post.photoAssetName {
                            Image(asset)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipped()
                        }

                        HStack(spacing: 4) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 10))
                                .foregroundStyle(AppTheme.Colors.locationText)
                            Text("\(post.buildingCode) · \(post.floor)")
                                .font(AppTheme.Typography.labelSmall)
                                .foregroundStyle(AppTheme.Colors.textPrimary)
                        }
                        .padding(.horizontal, AppTheme.Spacing.sm)
                        .padding(.vertical, 3)
                        .background(.white.opacity(0.92))
                        .clipShape(Capsule())
                        .padding(AppTheme.Spacing.sm)
                    }
                    .cornerRadius(AppTheme.Radius.lg)
                    .padding(.horizontal, AppTheme.Spacing.md)

                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        HStack(spacing: AppTheme.Spacing.sm) {
                            Circle()
                                .fill(AppTheme.Colors.primaryPale)
                                .frame(width: 38, height: 38)
                                .overlay(
                                    Text(String(post.hostUsername.prefix(2)).uppercased())
                                        .font(AppTheme.Typography.label.weight(.bold))
                                        .foregroundStyle(AppTheme.Colors.primary)
                                )

                            VStack(alignment: .leading, spacing: 1) {
                                Text(post.hostUsername)
                                    .font(AppTheme.Typography.username)
                                    .foregroundStyle(AppTheme.Colors.textPrimary)
                                Text(degreeAndYear)
                                    .font(AppTheme.Typography.bodySmall)
                                    .foregroundStyle(AppTheme.Colors.textSecondary)
                            }

                            Spacer()
                            PostStatusBadge(status: post.computedStatus)
                        }

                        Text(post.title)
                            .font(AppTheme.Typography.postTitle)
                            .foregroundStyle(AppTheme.Colors.textPrimary)

                        Text(dateText)
                            .font(AppTheme.Typography.bodySmall)
                            .foregroundStyle(AppTheme.Colors.textSecondary)

                        HStack(spacing: AppTheme.Spacing.sm) {
                            Text(timeText)
                                .font(AppTheme.Typography.label.weight(.semibold))
                                .foregroundStyle(.black)
                            if closingSoon {
                                Text("Closing soon")
                                    .font(AppTheme.Typography.labelSmall.weight(.semibold))
                                    .foregroundStyle(AppTheme.Colors.primary)
                            }
                        }

                        HStack(spacing: 4) {
                            Image(systemName: "person.2")
                                .font(.system(size: 11))
                                .foregroundStyle(AppTheme.Colors.textTertiary)
                            Text("Capacity \(post.capacity)")
                                .font(AppTheme.Typography.bodySmall)
                                .foregroundStyle(AppTheme.Colors.textSecondary)
                        }

                        HStack {
                            Text(post.vibe)
                                .font(AppTheme.Typography.labelSmall.weight(.semibold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, AppTheme.Spacing.sm)
                                .padding(.vertical, AppTheme.Spacing.xxs)
                                .background(AppTheme.Colors.primary)
                                .clipShape(Capsule())
                            Spacer()
                        }

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppTheme.Spacing.xs) {
                                ForEach(post.subjects, id: \.self) { subject in
                                    Text(subject)
                                        .font(AppTheme.Typography.labelSmall)
                                        .foregroundStyle(AppTheme.Colors.textSecondary)
                                        .padding(.horizontal, AppTheme.Spacing.sm)
                                        .padding(.vertical, AppTheme.Spacing.xxs)
                                        .background(Color.gray.opacity(0.18))
                                        .clipShape(Capsule())
                                }
                            }
                        }

                        Divider().background(AppTheme.Colors.divider)

                        HStack(spacing: 4) {
                            Image(systemName: "location")
                                .font(.system(size: 11))
                                .foregroundStyle(AppTheme.Colors.textTertiary)
                            Text("\(post.buildingCode) \(post.floor) · \(post.locationDescription)")
                                .font(AppTheme.Typography.bodySmall)
                                .foregroundStyle(AppTheme.Colors.textSecondary)
                        }

                        Text(post.bodyText)
                            .font(AppTheme.Typography.bodyMedium)
                            .foregroundStyle(AppTheme.Colors.textSecondary)

                        Button {
                            showFloorMap = true
                        } label: {
                            Text("See location on floor map")
                                .font(AppTheme.Typography.label.weight(.semibold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, AppTheme.Spacing.sm)
                                .background(AppTheme.Colors.primary)
                                .cornerRadius(AppTheme.Radius.md)
                        }
                    }
                    .padding(AppTheme.Spacing.md)
                    .background(AppTheme.Colors.surface)
                    .cornerRadius(AppTheme.Radius.lg)
                    .shadow(color: AppTheme.Shadows.card.color,
                            radius: AppTheme.Shadows.card.radius,
                            x: AppTheme.Shadows.card.x,
                            y: AppTheme.Shadows.card.y)
                    .padding(.horizontal, AppTheme.Spacing.md)

                    if isHost {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            Text("Session Management")
                                .font(AppTheme.Typography.heading2)
                                .foregroundStyle(AppTheme.Colors.textPrimary)

                            Toggle(isOn: Binding(
                                get: { isMarkedFull },
                                set: { newValue in
                                    if isFinished { return }
                                    if newValue {
                                        showFullConfirm = true
                                    } else {
                                        post.statusOverride = nil
                                        appState.updatePost(post)
                                    }
                                }
                            )) {
                                Text("Mark as Full")
                                    .font(AppTheme.Typography.bodyMedium)
                                    .foregroundStyle(isFinished ? AppTheme.Colors.textTertiary : AppTheme.Colors.textPrimary)
                            }
                            .disabled(isFinished)

                            Button {
                                if !isFinished {
                                    showEndConfirm = true
                                }
                            } label: {
                                Text("End Session")
                                    .font(AppTheme.Typography.bodyMedium.weight(.semibold))
                                    .foregroundStyle(isFinished ? AppTheme.Colors.textTertiary : .red)
                            }
                            .buttonStyle(.plain)
                            .disabled(isFinished)
                        }
                        .padding(AppTheme.Spacing.md)
                        .background(AppTheme.Colors.surface)
                        .cornerRadius(AppTheme.Radius.lg)
                        .shadow(color: AppTheme.Shadows.subtle.color,
                                radius: AppTheme.Shadows.subtle.radius,
                                x: AppTheme.Shadows.subtle.x,
                                y: AppTheme.Shadows.subtle.y)
                        .padding(.horizontal, AppTheme.Spacing.md)
                    }
                }
                .padding(.bottom, AppTheme.Spacing.xl)
            }
        }
        .navigationTitle("Post detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if isHost {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Edit") { showEdit = true }
                        Button("Delete", role: .destructive) {
                            appState.deletePost(post)
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundStyle(AppTheme.Colors.primary)
                    }
                }
            }
        }
        .alert("Mark session as full?", isPresented: $showFullConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Confirm") {
                post.statusOverride = .full
                appState.updatePost(post)
            }
        }
        .alert("End this session now?", isPresented: $showEndConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("End Session", role: .destructive) {
                post.statusOverride = .finished
                appState.updatePost(post)
            }
        } message: {
            Text("This cannot be undone. The session will remain finished.")
        }
        .sheet(isPresented: $showEdit) {
            EditPostView(post: $post)
                .onDisappear { appState.updatePost(post) }
        }
        .sheet(isPresented: $showFloorMap) {
            FloorMapPreviewSheet()
        }
    }
}

private struct FloorMapPreviewSheet: View {
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()

                ZStack {
                    Image("floorplan_sample")
                        .resizable()
                        .scaledToFit()

                    Image(systemName: "mappin")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(AppTheme.Colors.locationText)
                        .position(x: 180, y: 180)
                }
                .padding(AppTheme.Spacing.md)
            }
            .navigationTitle("Floor map")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
