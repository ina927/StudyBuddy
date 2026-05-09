import SwiftUI

struct PostCardView: View {
    let post: StudyPost

    private var degreeAndYear: String {
        let degree = post.hostDegrees.first ?? "-"
        return "\(degree), \(post.hostYear)"
    }

    private var timeText: String {
        let sameDay = Calendar.current.isDate(post.startTime, inSameDayAs: post.endTime)
        let start = post.startTime.formatted(date: .omitted, time: .shortened)
        let end = post.endTime.formatted(date: .omitted, time: .shortened)
        if sameDay {
            return "\(start) - \(end)"
        }
        return "\(post.startTime.formatted(date: .abbreviated, time: .shortened)) - \(post.endTime.formatted(date: .abbreviated, time: .shortened))"
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

                if let photo = post.photoAssetName {
                    Image(photo)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 110)
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

                if post.photoAssetName == nil {
                    Image(systemName: "camera")
                        .font(.system(size: 28))
                        .foregroundStyle(.white.opacity(0.6))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }

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

                HStack(alignment: .center, spacing: AppTheme.Spacing.xs) {
                    Image(systemName: "clock")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(AppTheme.Colors.primary)
                    Text(timeText)
                        .font(AppTheme.Typography.label.weight(.semibold))
                        .foregroundStyle(AppTheme.Colors.primary)

                    if closingSoon {
                        Text("Closing soon")
                            .font(AppTheme.Typography.labelSmall.weight(.semibold))
                            .foregroundStyle(AppTheme.Colors.busyText)
                            .padding(.horizontal, AppTheme.Spacing.xs)
                            .padding(.vertical, 3)
                            .background(AppTheme.Colors.busy)
                            .clipShape(Capsule())
                    }
                }

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
            .padding(AppTheme.Spacing.md)
            .background(AppTheme.Colors.surface)
        }
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.lg))
        .shadow(color: AppTheme.Shadows.card.color,
                radius: AppTheme.Shadows.card.radius,
                x: AppTheme.Shadows.card.x,
                y: AppTheme.Shadows.card.y)
    }

    private func vibeColor(_ vibe: String) -> Color {
        switch vibe {
        case "Silent Focus": return Color(red: 87/255, green: 107/255, blue: 194/255)
        case "Casual Co-study": return Color(red: 98/255, green: 163/255, blue: 121/255)
        case "Problem Solving": return Color(red: 238/255, green: 146/255, blue: 79/255)
        case "Exam Revision": return Color(red: 196/255, green: 95/255, blue: 126/255)
        case "Assignment Sprint": return Color(red: 121/255, green: 99/255, blue: 176/255)
        case "Peer Teaching": return Color(red: 79/255, green: 155/255, blue: 168/255)
        case "Discussion Heavy": return Color(red: 169/255, green: 122/255, blue: 84/255)
        case "Accountability Session": return Color(red: 96/255, green: 129/255, blue: 94/255)
        default: return AppTheme.Colors.primary
        }
    }
}
