//
//  PostStatusBadge.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI

struct PostStatusBadge: View {
    let status: StudyPost.Status
 
    private var bgColor: Color {
        switch status {
        case .notStarted: return AppTheme.Colors.primaryPale
        case .ongoing:    return AppTheme.Colors.available
        case .full:       return AppTheme.Colors.busy
        case .finished:   return AppTheme.Colors.unavailable
        }
    }
 
    private var textColor: Color {
        switch status {
        case .notStarted: return AppTheme.Colors.primary
        case .ongoing:    return AppTheme.Colors.availableText
        case .full:       return AppTheme.Colors.busyText
        case .finished:   return AppTheme.Colors.unavailableText
        }
    }
 
    private var icon: String {
        switch status {
        case .notStarted: return ""
        case .ongoing:    return " ✓"
        case .full:       return ""
        case .finished:   return ""
        }
    }
 
    var body: some View {
        Text(status.rawValue + icon)
            .font(AppTheme.Typography.labelSmall.weight(.semibold))
            .foregroundStyle(textColor)
            .padding(.horizontal, AppTheme.Spacing.sm)
            .padding(.vertical, AppTheme.Spacing.xxs)
            .background(bgColor)
            .clipShape(Capsule())
    }
}
