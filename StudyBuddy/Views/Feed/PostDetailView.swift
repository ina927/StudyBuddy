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
 
    private var isHost: Bool {
        appState.currentUser?.id == post.hostUserID
    }
 
    var body: some View {
        ZStack {
            AppTheme.Colors.background.ignoresSafeArea()
 
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
 
                    // ── Photo banner ──────────────────────────────────────
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
                        } else {
                            Image(systemName: "camera")
                                .font(.system(size: 36, weight: .light))
                                .foregroundStyle(.white.opacity(0.7))
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                        }
                    }
                    .cornerRadius(AppTheme.Radius.lg)
                    .padding(.horizontal, AppTheme.Spacing.md)
 
                    // ── Main info card ────────────────────────────────────
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
 
                        // Status + title
                        HStack(alignment: .top) {
                            Text(post.title)
                                .font(AppTheme.Typography.heading1)
                                .foregroundStyle(AppTheme.Colors.textPrimary)
                            Spacer()
                            PostStatusBadge(status: post.computedStatus)
                        }
 
                        // Body text
                        Text(post.bodyText)
                            .font(AppTheme.Typography.bodyMedium)
                            .foregroundStyle(AppTheme.Colors.textSecondary)
 
                        Divider().background(AppTheme.Colors.divider)
 
                        // Time — lavender pill
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 11))
                            Text("\(post.startTime.formatted(date: .omitted, time: .shortened))–\(post.endTime.formatted(date: .omitted, time: .shortened)), today")
                                .font(AppTheme.Typography.bodySmall)
                        }
                        .foregroundStyle(AppTheme.Colors.timePillText)
                        .padding(.horizontal, AppTheme.Spacing.sm)
                        .padding(.vertical, AppTheme.Spacing.xxs + 1)
                        .background(AppTheme.Colors.timePill)
                        .cornerRadius(AppTheme.Radius.pill)
 
                        // Location
                        HStack(spacing: 4) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 11))
                                .foregroundStyle(AppTheme.Colors.locationText)
                            Text("\(post.buildingCode) \(post.floor) · \(post.locationDescription)")
                                .font(AppTheme.Typography.bodySmall)
                                .foregroundStyle(AppTheme.Colors.textSecondary)
                        }
 
                        // Capacity
                        HStack(spacing: 4) {
                            Image(systemName: "person.2")
                                .font(.system(size: 11))
                                .foregroundStyle(AppTheme.Colors.textTertiary)
                            Text("Capacity \(post.capacity)")
                                .font(AppTheme.Typography.bodySmall)
                                .foregroundStyle(AppTheme.Colors.textSecondary)
                        }
 
                        // Subject tags
                        HStack(spacing: AppTheme.Spacing.xs) {
                            ForEach(post.subjects, id: \.self) { subject in
                                HStack(spacing: 3) {
                                    Image(systemName: "book.closed")
                                        .font(.system(size: 9))
                                    Text(subject)
                                        .font(AppTheme.Typography.labelSmall)
                                }
                                .foregroundStyle(AppTheme.Colors.tagText)
                                .padding(.horizontal, AppTheme.Spacing.sm)
                                .padding(.vertical, AppTheme.Spacing.xxs)
                                .background(AppTheme.Colors.tag)
                                .cornerRadius(AppTheme.Radius.pill)
                            }
                        }
 
                        Divider().background(AppTheme.Colors.divider)
 
                        // Detail rows
                        DetailRow(label: "Faculty",     value: post.hostDegrees.first ?? "-")
                        DetailRow(label: "Vibes",       value: post.vibe)
                        DetailRow(label: "Description", value: post.bodyText)
                    }
                    .padding(AppTheme.Spacing.md)
                    .background(AppTheme.Colors.surface)
                    .cornerRadius(AppTheme.Radius.lg)
                    .shadow(color: AppTheme.Shadows.card.color,
                            radius: AppTheme.Shadows.card.radius,
                            x: AppTheme.Shadows.card.x,
                            y: AppTheme.Shadows.card.y)
                    .padding(.horizontal, AppTheme.Spacing.md)
 
                    // ── Host controls ─────────────────────────────────────
                    if isHost {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            Text("Host Controls")
                                .font(AppTheme.Typography.heading2)
                                .foregroundStyle(AppTheme.Colors.textPrimary)
 
                            Picker("Status", selection: Binding(
                                get: { post.statusOverride ?? post.computedStatus },
                                set: { post.statusOverride = $0; appState.updatePost(post) }
                            )) {
                                Text("Not Started").tag(StudyPost.Status.notStarted)
                                Text("Ongoing").tag(StudyPost.Status.ongoing)
                                Text("Full").tag(StudyPost.Status.full)
                                Text("Finished").tag(StudyPost.Status.finished)
                            }
                            .pickerStyle(.segmented)
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
        .sheet(isPresented: $showEdit) {
            EditPostView(post: $post)
                .onDisappear { appState.updatePost(post) }
        }
    }
}
