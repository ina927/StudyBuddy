//
//  AppTheme.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI
 
struct AppTheme {
 
    // MARK: - Colors
    struct Colors {
        static let primary = Color(red: 123/255, green: 94/255,  blue: 167/255)
        static let primaryLight = Color(red: 155/255, green: 126/255, blue: 200/255)
        static let primaryPale = Color(red: 237/255, green: 232/255, blue: 245/255)
 
        // Warm cream — matches mockup background exactly
        static let background = Color(red: 250/255, green: 245/255, blue: 240/255)
        static let surface = Color(red: 255/255, green: 255/255, blue: 255/255)
        
        //White - commonpageheader background
        static let headerBackground = Color.white
 
        // Coral/salmon — filter chips border + text
        static let accent = Color(red: 244/255, green: 140/255, blue: 140/255)
        static let accentLight     = Color(red: 254/255, green: 235/255, blue: 235/255)
 
        // Yellow — subject tags
        static let tag             = Color(red: 245/255, green: 230/255, blue: 163/255)
        static let tagText         = Color(red: 138/255, green: 115/255, blue: 32/255)
 
        // Time pill — lavender
        static let timePill        = Color(red: 237/255, green: 232/255, blue: 245/255)
        static let timePillText    = Color(red: 107/255, green: 90/255,  blue: 140/255)
 
        // Status badges
        static let available       = Color(red: 200/255, green: 240/255, blue: 200/255)
        static let availableText   = Color(red: 46/255,  green: 125/255, blue: 50/255)
        static let busy            = Color(red: 255/255, green: 224/255, blue: 178/255)
        static let busyText        = Color(red: 230/255, green: 81/255,  blue: 0/255)
        static let unavailable     = Color(red: 255/255, green: 210/255, blue: 210/255)
        static let unavailableText = Color(red: 180/255, green: 40/255,  blue: 40/255)
 
        // Text
        static let textPrimary     = Color(red: 26/255,  green: 26/255,  blue: 46/255)
        static let textSecondary   = Color(red: 107/255, green: 107/255, blue: 138/255)
        static let textTertiary    = Color(red: 160/255, green: 160/255, blue: 184/255)
 
        // Icon tints
        static let iconActive      = Color(red: 123/255, green: 94/255,  blue: 167/255)
        static let iconInactive    = Color(red: 192/255, green: 186/255, blue: 208/255)
 
        // Location red pin
        static let locationText    = Color(red: 224/255, green: 90/255,  blue: 106/255)
 
        // Input field bg
        static let inputBg         = Color(red: 242/255, green: 238/255, blue: 252/255)
        static let divider         = Color(red: 220/255, green: 215/255, blue: 235/255)
    }
 
    // MARK: - Typography
    struct Typography {
        static let appTitle    = Font.system(size: 28, weight: .bold,     design: .rounded)
        static let heading1    = Font.system(size: 22, weight: .bold,     design: .rounded)
        static let heading2    = Font.system(size: 18, weight: .semibold, design: .rounded)
        static let bodyLarge   = Font.system(size: 16, weight: .regular,  design: .rounded)
        static let bodyMedium  = Font.system(size: 14, weight: .regular,  design: .rounded)
        static let bodySmall   = Font.system(size: 12, weight: .regular,  design: .rounded)
        static let label       = Font.system(size: 13, weight: .medium,   design: .rounded)
        static let labelSmall  = Font.system(size: 11, weight: .medium,   design: .rounded)
        static let username    = Font.system(size: 16, weight: .bold,     design: .rounded)
        static let postTitle   = Font.system(size: 17, weight: .bold,     design: .rounded)
    }
 
    // MARK: - Spacing
    struct Spacing {
        static let xxs: CGFloat = 4
        static let xs:  CGFloat = 8
        static let sm:  CGFloat = 12
        static let md:  CGFloat = 16
        static let lg:  CGFloat = 24
        static let xl:  CGFloat = 32
        static let xxl: CGFloat = 48
    }
 
    // MARK: - Corner Radius
    struct Radius {
        static let sm:   CGFloat = 8
        static let md:   CGFloat = 14
        static let lg:   CGFloat = 20
        static let xl:   CGFloat = 28
        static let pill: CGFloat = 999
    }
 
    // MARK: - Shadows
    struct Shadows {
        static let card   = Shadow(
            color: Color(red: 123/255, green: 94/255, blue: 167/255).opacity(0.12),
            radius: 14, x: 0, y: 5)
        static let subtle = Shadow(
            color: Color.black.opacity(0.05),
            radius: 6, x: 0, y: 2)
    }
 
    struct Shadow {
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
    }
}
 
// MARK: - View Modifiers
 
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppTheme.Colors.surface)
            .cornerRadius(AppTheme.Radius.lg)
            .shadow(color: AppTheme.Shadows.card.color,
                    radius: AppTheme.Shadows.card.radius,
                    x: AppTheme.Shadows.card.x,
                    y: AppTheme.Shadows.card.y)
    }
}
 
struct SubjectTagStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(AppTheme.Typography.labelSmall)
            .foregroundStyle(AppTheme.Colors.tagText)
            .padding(.horizontal, AppTheme.Spacing.sm)
            .padding(.vertical, AppTheme.Spacing.xxs)
            .background(AppTheme.Colors.tag)
            .cornerRadius(AppTheme.Radius.pill)
    }
}
 
struct VibeChipStyle: ViewModifier {
    var isSelected: Bool
    func body(content: Content) -> some View {
        content
            .font(AppTheme.Typography.label)
            .foregroundStyle(isSelected ? .white : AppTheme.Colors.primary)
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.vertical, AppTheme.Spacing.xxs + 2)
            .background(isSelected ? AppTheme.Colors.primary : AppTheme.Colors.primaryPale)
            .cornerRadius(AppTheme.Radius.pill)
    }
}
 
extension View {
    func cardStyle() -> some View { modifier(CardStyle()) }
    func subjectTagStyle() -> some View { modifier(SubjectTagStyle()) }
    func vibeChip(isSelected: Bool) -> some View { modifier(VibeChipStyle(isSelected: isSelected)) }
}
