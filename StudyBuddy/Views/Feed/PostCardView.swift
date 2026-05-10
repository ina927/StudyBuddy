//
//  PostCardView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI

struct PostCardView: View {
    @EnvironmentObject var appState: AppState
    @State private var authorProfilePic: String? = nil
    let post: StudyPost

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

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .fill(AppTheme.Colors.primaryLight.opacity(0.45))
                    .frame(height: 110)

                if let photo = post.photoAssetName, let url = URL(string: photo) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 130)
                            .clipped()
                    } placeholder: {
                        Rectangle()
                            .fill(Color.purple.opacity(0.25))
                            .frame(height: 130)
                    }
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

            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                HStack(spacing: AppTheme.Spacing.sm) {
                    if let pic = authorProfilePic, let url = URL(string: pic) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 34, height: 34)
                                .clipShape(Circle())
                        } placeholder: {
                            defaultAvatar
                        }
                    } else {
                        defaultAvatar
                    }

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

                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Text(post.title)
                        .font(AppTheme.Typography.postTitle)
                        .foregroundStyle(AppTheme.Colors.textPrimary)

                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 11))
                            .foregroundStyle(AppTheme.Colors.textTertiary)
                        Text(dateText)
                            .font(AppTheme.Typography.bodySmall)
                            .foregroundStyle(AppTheme.Colors.textSecondary)
                    }

                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 11))
                            .foregroundStyle(AppTheme.Colors.textTertiary)
                        Text(timeText)
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
                }

                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    HStack {
                        Text(post.vibe)
                            .font(AppTheme.Typography.labelSmall.weight(.semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, AppTheme.Spacing.sm)
                            .padding(.vertical, AppTheme.Spacing.xxs)
                            .background(vibeColor(post.vibe))
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
                }
            }
            .padding(AppTheme.Spacing.md)
            .background(AppTheme.Colors.surface)
        }
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.lg))
        .shadow(color: AppTheme.Shadows.card.color,
                radius: AppTheme.Shadows.card.radius,
                x: AppTheme.Shadows.card.x,
                y: AppTheme.Shadows.card.y)
        .task {
            if let user = await appState.getUser(id: post.hostUserID) {
                authorProfilePic = user.profilePic
            }
        }
        
    }
    
    var defaultAvatar: some View {
       Circle()
           .fill(Color.purple.opacity(0.2))
           .frame(width: 34, height: 34)
           .overlay(
               Text(String(post.hostUsername.prefix(2)).uppercased())
                   .font(.caption.bold())
           )
    }
    

    private func vibeColor(_ vibe: String) -> Color {
        switch vibe {
        case "Silent Focus": return Color(red: 109/255, green: 95/255, blue: 171/255)
        case "Casual Co-study": return Color(red: 93/255, green: 137/255, blue: 168/255)
        case "Problem Solving": return Color(red: 122/255, green: 120/255, blue: 186/255)
        case "Exam Revision": return Color(red: 148/255, green: 99/255, blue: 168/255)
        case "Assignment Sprint": return Color(red: 135/255, green: 96/255, blue: 146/255)
        case "Peer Teaching": return Color(red: 90/255, green: 132/255, blue: 145/255)
        case "Discussion Heavy": return Color(red: 132/255, green: 110/255, blue: 170/255)
        case "Accountability Session": return Color(red: 99/255, green: 114/255, blue: 168/255)
        default: return AppTheme.Colors.primary
        }
    }
}
