//
//  PostStatusBadge.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI

struct PostStatusBadge: View {
    let status: StudyPost.Status

    private var color: Color {
        switch status {
        case .notStarted: return .gray
        case .ongoing: return .green
        case .full: return .orange
        case .finished: return .red
        }
    }

    var body: some View {
        Text(status.rawValue)
            .font(.caption2.weight(.semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.14))
            .clipShape(Capsule())
    }
}
