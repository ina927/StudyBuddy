//
//  MyPostCard.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI

struct MyPostCard: View {
    @EnvironmentObject private var appState: AppState
    @Binding var post: StudyPost
    var isPast: Bool = false
    @State private var showingEdit = false

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
            EditPostView(post: $post)
        }
    }

    private var imagePlaceholder: some View {
        ZStack {
            AppTheme.Colors.primary.opacity(isPast ? 0.35 : 0.75)
            if let urlString = post.photoAssetName, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill().opacity(isPast ? 0.6 : 1)
                    default:
                        Image(systemName: "camera").font(.title2).foregroundStyle(.white.opacity(0.75))
                    }
                }
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
                        .foregroundStyle(AppTheme.Colors.primary)
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
        let end = fmt.string(from: post.endTime).lowercased()
        let isToday = Calendar.current.isDateInToday(post.startTime)
        if isToday { return "\(start) - \(end) today" }
        let dayFmt = DateFormatter()
        dayFmt.dateFormat = "MMM d"
        return "\(start) - \(end), \(dayFmt.string(from: post.startTime))"
    }
}
