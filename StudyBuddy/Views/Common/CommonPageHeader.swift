//
//  CommonPageHeader.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI
 
struct CommonPageHeader: View {
    let title: String
    var trailing: AnyView? = nil
 
    var body: some View {
        HStack {
            Text(title)
                .font(AppTheme.Typography.appTitle)
                .foregroundStyle(AppTheme.Colors.textPrimary)
            Spacer()
            trailing
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.top, AppTheme.Spacing.sm)
        .padding(.bottom, AppTheme.Spacing.xs)
        .background(AppTheme.Colors.headerBackground)
    }
}
