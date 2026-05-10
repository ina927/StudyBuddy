//
//  CreatePostRootView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI
import CoreLocation

struct CreatePostRootView: View {
    @EnvironmentObject private var appState: AppState

    @State private var draft = CreatePostDraft()
    @State private var step = 1
    private let totalSteps = 3

    @State private var postedDraft: CreatePostDraft? = nil

    @State private var showNearestBuildingPopup = false
    @State private var nearestBuilding: BuildingOption?
    @State private var shouldAutoExpandBuildingId: String?

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()

                Group {
                    if let posted = postedDraft {
                        PostSuccessfulView(
                            postedDraft: posted,
                            onGoFeed: {
                                appState.selectedTab = 0
                                resetDraftFlow()
                            },
                            onCreateAnother: {
                                resetDraftFlow()
                            }
                        )
                    } else if step == 1 {
                        BuildingDirectoryView(
                            autoExpandBuildingID: shouldAutoExpandBuildingId
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
                                postedDraft = draft
                            },
                            onBackToLocation: {
                                withAnimation { step = 2 }
                            }
                        )
                    }
                }
                .background(AppTheme.Colors.background)
            }
            .safeAreaInset(edge: .top) {
                if postedDraft == nil {
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
            }
            .navigationBarHidden(true)
            .onAppear {
                appState.start()
                if step == 1 && postedDraft == nil {
                    showNearestBuildingSuggestion()
                }
            }
            .alert(
                "Nearby Building Found",
                isPresented: $showNearestBuildingPopup
            ) {
                if let b = nearestBuilding {
                    Button("Select \(b.code)") {
                        shouldAutoExpandBuildingId = b.id
                    }
                }
                Button("No, choose another building", role: .cancel) {}
            } message: {
                if let b = nearestBuilding {
                    Text("The nearest building to your current location is \(b.name) (\(b.code)).")
                } else {
                    Text("Please choose your building manually.")
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

    private func showNearestBuildingSuggestion() {
        guard let loc = appState.currentLoc else { return }

        let candidates = MetadataStore.buildings
            .map { b -> (BuildingOption, CLLocationDistance) in
                let center = CLLocation(latitude: b.lat, longitude: b.long)
                return (b, center.distance(from: loc))
            }
            .sorted(by: { $0.1 < $1.1 })

        guard let nearest = candidates.first?.0 else { return }
        nearestBuilding = nearest
        showNearestBuildingPopup = true
    }

    private func resetDraftFlow() {
        draft = CreatePostDraft()
        postedDraft = nil
        shouldAutoExpandBuildingId = nil
        withAnimation { step = 1 }
    }
}

private struct PostSuccessfulView: View {
    let postedDraft: CreatePostDraft
    let onGoFeed: () -> Void
    let onCreateAnother: () -> Void

    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(AppTheme.Colors.primary)

            Text("Post Successful")
                .font(AppTheme.Typography.heading1)
                .foregroundStyle(AppTheme.Colors.textPrimary)

            Text("\(postedDraft.buildingCode) \(postedDraft.floor)")
                .font(AppTheme.Typography.bodySmall)
                .foregroundStyle(AppTheme.Colors.textSecondary)

            VStack(spacing: AppTheme.Spacing.sm) {
                Button(action: onGoFeed) {
                    Text("Go to Feed")
                        .font(AppTheme.Typography.label.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.sm)
                        .background(AppTheme.Colors.primary)
                        .cornerRadius(AppTheme.Radius.md)
                }

                Button(action: onCreateAnother) {
                    Text("Create Another Post")
                        .font(AppTheme.Typography.label.weight(.semibold))
                        .foregroundStyle(AppTheme.Colors.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.sm)
                        .background(AppTheme.Colors.surface)
                        .cornerRadius(AppTheme.Radius.md)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)

            Spacer()
        }
        .padding(AppTheme.Spacing.md)
    }
}
