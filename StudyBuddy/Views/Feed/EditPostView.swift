//
//  EditPostView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI
import CoreLocation

struct EditPostView: View {
    @Binding var post: StudyPost
    @Environment(\.dismiss) private var dismiss

    @State private var draft = CreatePostDraft()
    @State private var step = 3
    private let totalSteps = 3

    @State private var hasInitialized = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()

                Group {
                    if step == 1 {
                        BuildingDirectoryView(
                            autoExpandBuildingID: nil
                        ) { code, name, floor, asset in
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
                        PostDetailsView(
                            draft: $draft,
                            onPosted: {
                                saveChangesToPost()
                                dismiss()
                            },
                            onBackToLocation: {
                                withAnimation { step = 2 }
                            },
                            isEditMode: true
                        )
                    }
                }
                .background(AppTheme.Colors.background)
            }
            .safeAreaInset(edge: .top) {
                VStack(spacing: AppTheme.Spacing.xs) {
                    HStack {
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
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundStyle(AppTheme.Colors.primary)
                                    .frame(width: 32, height: 32)
                            }
                        }

                        Spacer()

                        Text(stepTitle)
                            .font(AppTheme.Typography.heading2)
                            .foregroundStyle(AppTheme.Colors.textPrimary)

                        Spacer()
                        Color.clear.frame(width: 32, height: 32)
                    }
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .padding(.top, AppTheme.Spacing.xs)

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
            .onAppear {
                if !hasInitialized {
                    initializeDraftFromPost()
                    hasInitialized = true
                }
            }
        }
    }

    private var stepTitle: String {
        switch step {
        case 1: return "Edit Post"
        case 2: return "Set Location"
        default: return "Edit Details"
        }
    }

    private func initializeDraftFromPost() {
        draft.buildingCode = post.buildingCode
        draft.buildingName = post.buildingName
        draft.floor = post.floor
        draft.floorPlanAssetName = post.floorPlanAssetName
        draft.pinX = post.pinX
        draft.pinY = post.pinY
        draft.locationDescription = post.locationDescription
        draft.title = post.title
        draft.postBody = post.bodyText
        draft.subjects = post.subjects
        draft.vibe = post.vibe
        draft.capacity = post.capacity
        draft.startTime = post.startTime
        draft.endTime = post.endTime
        draft.existingPhotoAssetName = post.photoAssetName
    }

    private func saveChangesToPost() {
        post.buildingCode = draft.buildingCode
        post.buildingName = draft.buildingName
        post.floor = draft.floor
        post.floorPlanAssetName = draft.floorPlanAssetName
        post.pinX = draft.pinX
        post.pinY = draft.pinY
        post.locationDescription = draft.locationDescription
        post.title = draft.title
        post.bodyText = draft.postBody
        post.subjects = draft.subjects
        post.vibe = draft.vibe
        post.capacity = draft.capacity
        post.startTime = draft.startTime
        post.endTime = draft.endTime
        // Update photo if a new one was selected
        if draft.postImage != nil {
            // In a real app, upload to Firebase Storage and get URL
            post.photoAssetName = "updated_photo_\(UUID().uuidString)"
        }
        // Keep existing photo if no new photo was selected
    }
}
