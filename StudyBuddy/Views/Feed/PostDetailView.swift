import SwiftUI

struct PostDetailView: View {
    @EnvironmentObject private var appState: AppState
    @State var post: StudyPost
    @State private var showEdit = false

    private var isHost: Bool {
        appState.currentUser?.id == post.hostUserID
    }

    private var hostInfoText: String {
        let degree = post.hostDegrees.joined(separator: ", ")
        if let major = post.hostMajor, !major.isEmpty {
            return "\(degree) · \(post.hostYear) · \(major)"
        }
        return "\(degree) · \(post.hostYear)"
    }

    var body: some View {
        ZStack {
            AppTheme.Colors.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
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

                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        HStack(alignment: .top) {
                            Text(post.title)
                                .font(AppTheme.Typography.heading1)
                                .foregroundStyle(AppTheme.Colors.textPrimary)
                            Spacer()
                            PostStatusBadge(status: post.computedStatus)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(post.hostUsername)
                                .font(AppTheme.Typography.label.weight(.semibold))
                                .foregroundStyle(AppTheme.Colors.textPrimary)
                            Text(hostInfoText)
                                .font(AppTheme.Typography.bodySmall)
                                .foregroundStyle(AppTheme.Colors.textSecondary)
                        }

                        Divider().background(AppTheme.Colors.divider)

                        HStack(spacing: 6) {
                            Image(systemName: "clock")
                                .font(.system(size: 11))
                            Text("\(post.startTime.formatted(date: .abbreviated, time: .shortened)) - \(post.endTime.formatted(date: .abbreviated, time: .shortened))")
                                .font(AppTheme.Typography.bodySmall)
                        }
                        .foregroundStyle(AppTheme.Colors.timePillText)
                        .padding(.horizontal, AppTheme.Spacing.sm)
                        .padding(.vertical, AppTheme.Spacing.xxs + 1)
                        .background(AppTheme.Colors.timePill)
                        .cornerRadius(AppTheme.Radius.pill)

                        HStack(spacing: 4) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 11))
                                .foregroundStyle(AppTheme.Colors.locationText)
                            Text("\(post.buildingCode) \(post.floor) · \(post.locationDescription)")
                                .font(AppTheme.Typography.bodySmall)
                                .foregroundStyle(AppTheme.Colors.textSecondary)
                        }

                        HStack(spacing: 4) {
                            Image(systemName: "person.2")
                                .font(.system(size: 11))
                                .foregroundStyle(AppTheme.Colors.textTertiary)
                            Text("Capacity \(post.capacity)")
                                .font(AppTheme.Typography.bodySmall)
                                .foregroundStyle(AppTheme.Colors.textSecondary)
                        }

                        Text(post.vibe)
                            .font(AppTheme.Typography.labelSmall.weight(.semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, AppTheme.Spacing.sm)
                            .padding(.vertical, AppTheme.Spacing.xxs)
                            .background(AppTheme.Colors.primary)
                            .cornerRadius(AppTheme.Radius.pill)

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

                        Text(post.bodyText)
                            .font(AppTheme.Typography.bodyMedium)
                            .foregroundStyle(AppTheme.Colors.textSecondary)
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

                            Text("Time-based status updates automatically. Use these actions only when needed.")
                                .font(AppTheme.Typography.bodySmall)
                                .foregroundStyle(AppTheme.Colors.textSecondary)

                            HStack(spacing: AppTheme.Spacing.sm) {
                                Button {
                                    post.statusOverride = .full
                                    appState.updatePost(post)
                                } label: {
                                    Text("Mark as Full")
                                        .font(AppTheme.Typography.label.weight(.semibold))
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, AppTheme.Spacing.sm)
                                        .background(AppTheme.Colors.busyText)
                                        .cornerRadius(AppTheme.Radius.md)
                                }

                                Button {
                                    post.statusOverride = .finished
                                    appState.updatePost(post)
                                } label: {
                                    Text("End Session")
                                        .font(AppTheme.Typography.label.weight(.semibold))
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, AppTheme.Spacing.sm)
                                        .background(AppTheme.Colors.unavailableText)
                                        .cornerRadius(AppTheme.Radius.md)
                                }
                            }
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
