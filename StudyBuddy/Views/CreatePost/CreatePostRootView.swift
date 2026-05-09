//
//  CreatePostRootView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI

struct CreatePostRootView: View {
    @State private var draft = CreatePostDraft()
    @State private var step = 1
    private let totalSteps = 3
 
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()
 
                // ── Step content ──────────────────────────────────────────
                Group {
                    if step == 1 {
                        BuildingDirectoryView { code, name, floor, asset in
                            draft.buildingCode = code
                            draft.buildingName = name
                            draft.floor = floor
                            draft.floorPlanAssetName = asset
                            withAnimation { step = 2 }
                        }
                    } else if step == 2 {
                        FloorPlanPinView(draft: $draft) {
                            withAnimation { step = 3 }
                        }
                    } else {
                        PostDetailsView(draft: $draft) {
                            draft = CreatePostDraft()
                            withAnimation { step = 1 }
                        }
                    }
                }
                .background(AppTheme.Colors.background)
            }
 
            // ── Custom nav bar + progress bar ─────────────────────────────
            .safeAreaInset(edge: .top) {
                VStack(spacing: AppTheme.Spacing.xs) {
 
                    // Nav row
                    HStack {
                        // Back button
                        if step > 1 {
                            Button {
                                withAnimation { step -= 1 }
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundStyle(AppTheme.Colors.primary)
                                    .frame(width: 32, height: 32)
                            }
                        } else {
                            Color.clear.frame(width: 32, height: 32)
                        }
 
                        Spacer()
 
                        // Step title
                        Text(stepTitle)
                            .font(AppTheme.Typography.heading2)
                            .foregroundStyle(AppTheme.Colors.textPrimary)
 
                        Spacer()
 
                        // Post button (step 3 only)
                        if step == 3 {
                            Button {
                                // Post action is handled inside PostDetailsView
                            } label: {
                                Text("Post")
                                    .font(AppTheme.Typography.label.weight(.semibold))
                                    .foregroundStyle(AppTheme.Colors.primary)
                                    .frame(width: 32, height: 32)
                            }
                        } else {
                            Color.clear.frame(width: 32, height: 32)
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .padding(.top, AppTheme.Spacing.xs)
 
                    // Progress bar
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppTheme.Colors.primaryPale)
                            .frame(height: 4)
 
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppTheme.Colors.primary)
                            .frame(height: 4)
                            .scaleEffect(
                                x: CGFloat(step) / CGFloat(totalSteps),
                                y: 1,
                                anchor: .leading
                            )
                            .animation(.easeInOut(duration: 0.3), value: step)
                    }
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .padding(.bottom, AppTheme.Spacing.xs)
                }
                .background(AppTheme.Colors.headerBackground)
            }
            .navigationBarHidden(true)
        }
    }
 
    private var stepTitle: String {
        switch step {
        case 1: return "Create Post"
        case 2: return "Set Location"
        default: return "New Post"
        }
    }
}

