//
//  MainTabView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            FeedView()
                .tabItem { Label("Feed", systemImage: "list.bullet.rectangle") }
                .tag(0)

            CreatePostRootView()
                .tabItem { Label("Create", systemImage: "plus.circle") }
                .tag(1)

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
                .tag(2)
        }
        .accentColor(AppTheme.Colors.primary)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(AppTheme.Colors.surface)
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppTheme.Colors.primary)
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(AppTheme.Colors.primary)]
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppTheme.Colors.iconInactive)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(AppTheme.Colors.iconInactive)]
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

