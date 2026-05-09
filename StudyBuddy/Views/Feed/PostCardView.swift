//
//  PostCardView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI

struct PostCardView: View {
    let post: StudyPost
    @State private var expanded = false
 
    var body: some View {
        VStack(spacing: 0) {
 
            // ── Photo banner ──────────────────────────────────────────────
            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .fill(AppTheme.Colors.primaryLight.opacity(0.45))
                    .frame(height: 110)
 
                if let photo = post.photoAssetName {
                    Image(photo)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 110)
                        .clipped()
                }
 
                // Location pill — red icon, black text
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(AppTheme.Colors.locationText)
                    Text("\(post.buildingCode).\(post.floor).\(post.locationDescription.components(separatedBy: " ").last ?? "")")
                        .font(AppTheme.Typography.labelSmall)
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                }
                .padding(.horizontal, AppTheme.Spacing.sm)
                .padding(.vertical, 3)
                .background(.white.opacity(0.92))
                .clipShape(Capsule())
                .padding(AppTheme.Spacing.sm)
 
                // Camera placeholder
                if post.photoAssetName == nil {
                    Image(systemName: "camera")
                        .font(.system(size: 28))
                        .foregroundStyle(.white.opacity(0.6))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
 
            // ── Card body ─────────────────────────────────────────────────
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
 
                // User row
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
                        Text(post.hostYear)
                            .font(AppTheme.Typography.bodySmall)
                            .foregroundStyle(AppTheme.Colors.textSecondary)
                    }
 
                    Spacer()
                    PostStatusBadge(status: post.computedStatus)
                }
 
                // Title
                Text(post.title)
                    .font(AppTheme.Typography.postTitle)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
 
                // ── Time — 보라색 동그라미 + 텍스트 ─────────────────────
                HStack(spacing: AppTheme.Spacing.xs) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.Colors.primary)
                            .frame(width: 20, height: 20)
                        Image(systemName: "clock")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.white)
                    }
                    Text("\(post.startTime.formatted(date: .omitted, time: .shortened))–\(post.endTime.formatted(date: .omitted, time: .shortened)), today")
                        .font(AppTheme.Typography.bodySmall)
                        .foregroundStyle(AppTheme.Colors.timePillText)
                }
                .padding(.horizontal, AppTheme.Spacing.sm)
                .padding(.vertical, AppTheme.Spacing.xxs + 1)
                .background(AppTheme.Colors.timePill)
                .cornerRadius(AppTheme.Radius.pill)
 
                // Tags
                HStack(spacing: AppTheme.Spacing.xs) {
                    ForEach(post.subjects.prefix(2), id: \.self) { subject in
                        Text(subject).subjectTagStyle()
                    }
                }
 
                // ── Expanded details ──────────────────────────────────────
                if expanded {
                    Divider()
                        .background(AppTheme.Colors.divider)
 
                    VStack(spacing: AppTheme.Spacing.xs) {
                        DetailRow(label: "Faculty",
                                  value: post.hostDegrees.first ?? "-")
                        DetailRow(label: "Vibes",
                                  value: post.vibe)
                        DetailRow(label: "Description",
                                  value: post.bodyText)
                    }
                }
 
                // Show more / less
                HStack {
                    Spacer()
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) { expanded.toggle() }
                    } label: {
                        HStack(spacing: 4) {
                            Text(expanded ? "Show less" : "Show more")
                            Image(systemName: expanded ? "chevron.up" : "chevron.down")
                                .font(.system(size: 10))
                        }
                        .font(AppTheme.Typography.label)
                        .foregroundStyle(AppTheme.Colors.primary)
                    }
                    Spacer()
                }
                .padding(.top, AppTheme.Spacing.xxs)
            }
            .padding(AppTheme.Spacing.md)
            .background(AppTheme.Colors.surface)
        }
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.lg))
        .shadow(color: AppTheme.Shadows.card.color,
                radius: AppTheme.Shadows.card.radius,
                x: AppTheme.Shadows.card.x,
                y: AppTheme.Shadows.card.y)
    }
}
 
// MARK: - Detail Row
struct DetailRow: View {
    let label: String
    let value: String
 
    var body: some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
            Text(label)
                .font(AppTheme.Typography.bodySmall.weight(.medium))
                .foregroundStyle(AppTheme.Colors.textTertiary)
                .frame(width: 80, alignment: .leading)
            Text(value)
                .font(AppTheme.Typography.bodySmall)
                .foregroundStyle(AppTheme.Colors.textSecondary)
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }
}
