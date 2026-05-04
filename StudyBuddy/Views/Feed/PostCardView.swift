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
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(Color.purple.opacity(0.25))
                    .frame(height: 130)

                if let photo = post.photoAssetName {
                    Image(photo)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 130)
                        .clipped()
                }

                Label("\(post.buildingCode).\(post.floor)", systemImage: "mappin.circle.fill")
                    .font(.caption2)
                    .padding(6)
                    .background(.white.opacity(0.85))
                    .clipShape(Capsule())
                    .padding(10)
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Circle()
                        .fill(Color.purple.opacity(0.2))
                        .frame(width: 34, height: 34)
                        .overlay(Text(String(post.hostUsername.prefix(2)).uppercased()).font(.caption.bold()))

                    VStack(alignment: .leading, spacing: 1) {
                        Text(post.hostUsername).font(.subheadline.bold())
                        Text(post.hostYear).font(.caption).foregroundStyle(.secondary)
                    }

                    Spacer()
                    PostStatusBadge(status: post.computedStatus)
                }

                Text(post.title).font(.headline)

                HStack(spacing: 6) {
                    Label("\(post.startTime.formatted(date: .omitted, time: .shortened))-\(post.endTime.formatted(date: .omitted, time: .shortened))", systemImage: "clock")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 6) {
                    Text(post.vibe).tagStyle()
                    ForEach(post.subjects.prefix(2), id: \.self) { subject in
                        Text(subject).tagStyle()
                    }
                }

                if expanded {
                    Divider()
                    Label(post.locationDescription, systemImage: "location")
                        .font(.caption)
                    Label("Capacity \(post.capacity)", systemImage: "person.2")
                        .font(.caption)
                    Text(post.bodyText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Button(expanded ? "Show less" : "Show more") {
                    withAnimation { expanded.toggle() }
                }
                .font(.caption)
                .foregroundStyle(.purple)
            }
            .padding(12)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.separator), lineWidth: 0.6))
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}

private extension Text {
    func tagStyle() -> some View {
        self.font(.caption2)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(.tertiarySystemFill))
            .clipShape(Capsule())
    }
}
