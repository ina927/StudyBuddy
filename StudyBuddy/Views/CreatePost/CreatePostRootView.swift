//
//  CreatePostRootView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI
import CoreLocation

struct CreatePostRootView: View {
    @EnvironmentObject var appState: AppState
    @State private var draft = CreatePostDraft()
    @State private var step = 1
    @State private var postedDraft: CreatePostDraft? = nil
    @State private var detectedBuildings: [BuildingOption] = []
    @State private var showBuildingDetection = false
    private let totalSteps = 3

    var body: some View {
        NavigationStack {
            if let done = postedDraft {
                PostSuccessView(draft: done) {
                    postedDraft = nil
                    draft = CreatePostDraft()
                    withAnimation { step = 1 }
                    appState.selectedTab = 0
                }
            } else {
                ZStack {
                    AppTheme.Colors.background.ignoresSafeArea()

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
                                postedDraft = draft
                            }
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
                                Color.clear.frame(width: 32, height: 32)
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
                .confirmationDialog("Are you in one of these buildings?", isPresented: $showBuildingDetection, titleVisibility: .visible) {
                    ForEach(detectedBuildings) { building in
                        Button(building.label) {
                            draft.buildingCode = building.code
                            draft.buildingName = building.name
                            withAnimation { step = 2 }
                        }
                    }
                    Button("None of these", role: .cancel) { }
                }
                .onAppear {
                    if let loc = appState.currentLoc {
                        let detected = appState.detectBuilding(from: loc)
                        if let detected, !detected.isEmpty {
                            detectedBuildings = detected
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                showBuildingDetection = true
                            }
                        }
                    }
                }
            }
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
