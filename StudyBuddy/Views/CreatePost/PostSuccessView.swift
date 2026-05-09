//
//  PostSuccessView.swift
//  StudyBuddy
//
//  Created by Zizhu on 8/5/2026.
//
import SwiftUI

struct PostSuccessView: View {
    let draft: CreatePostDraft
    let onDone: () -> Void

    var body: some View {
        ZStack {
            AppTheme.Colors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.12))
                        .frame(width: 100, height: 100)
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.green)
                }
                .padding(.bottom, 20)

                Text("Posted successfully!")
                    .font(.title2.weight(.bold))
                    .padding(.bottom, 6)

                Text("Your study session is now live.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer().frame(height: 40)

                VStack(alignment: .leading, spacing: 12) {
                    Text(draft.title.isEmpty ? "Study Session" : draft.title)
                        .font(.headline)
                        .lineLimit(1)

                    HStack(spacing: 16) {
                        Label("\(draft.buildingCode) · \(draft.floor)", systemImage: "mappin.fill")
                        Label(timeRange, systemImage: "clock")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                    if !draft.subjects.isEmpty {
                        HStack(spacing: 6) {
                            ForEach(draft.subjects.prefix(3), id: \.self) { subject in
                                Text(subject)
                                    .font(.caption.weight(.medium))
                                    .foregroundStyle(AppTheme.Colors.primary)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(AppTheme.Colors.primaryPale)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.07), radius: 6, x: 0, y: 3)
                .padding(.horizontal, 24)

                Spacer()

                Button(action: onDone) {
                    Text("Back to home")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .background(AppTheme.Colors.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                onDone()
            }
        }
    }

    private var timeRange: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "h:mma"
        return "\(fmt.string(from: draft.startTime).lowercased()) – \(fmt.string(from: draft.endTime).lowercased())"
    }
}
