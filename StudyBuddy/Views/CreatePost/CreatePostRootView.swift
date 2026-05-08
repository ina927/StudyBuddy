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
    @State private var detectedBuildings: [BuildingOption] = []
    @State private var showBuildingDetection = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    if step > 1 {
                        Button { step -= 1 } label: {
                            Image(systemName: "chevron.left")
                                .font(.headline)
                                .frame(width: 32, height: 32)
                        }
                        .buttonStyle(.plain)
                    } else {
                        Color.clear.frame(width: 32, height: 32)
                    }
                    Spacer()
                    Text("Create Post").font(.headline)
                    Spacer()
                    Color.clear.frame(width: 32, height: 32)
                }
                .padding(.horizontal)
                .padding(.top, 8)

                ProgressView(value: Double(step), total: 3)
                    .padding(.horizontal)
                    .padding(.top, 6)
                    .padding(.bottom, 10)

                Group {
                    if step == 1 {
                        BuildingDirectoryView { code, name, floor, asset in
                            draft.buildingCode = code
                            draft.buildingName = name
                            draft.floor = floor
                            draft.floorPlanAssetName = asset
                            step = 2
                        }
                    } else if step == 2 {
                        FloorPlanPinView(draft: $draft) { step = 3 }
                    } else {
                        PostDetailsView(draft: $draft) {
                            draft = CreatePostDraft()
                            step = 1
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .confirmationDialog("Are you in one of these buildings?", isPresented: $showBuildingDetection, titleVisibility: .visible) {
                ForEach(detectedBuildings) { building in
                    Button(building.label) {
                        draft.buildingCode = building.code
                        draft.buildingName = building.name
                        step = 2
                    }
                }
                Button("None of these", role: .cancel) { }
            }
            .onAppear {
                if let location = appState.currentLoc {
                    let detected = appState.detectBuilding(from: CLLocation(latitude: -33.88398260974563, longitude: 151.1991565131521))
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
