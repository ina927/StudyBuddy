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
 
            appearance.stackedLayoutAppearance.selected.iconColor =
                UIColor(AppTheme.Colors.primary)
            appearance.stackedLayoutAppearance.selected.titleTextAttributes =
                [.foregroundColor: UIColor(AppTheme.Colors.primary)]
 
            appearance.stackedLayoutAppearance.normal.iconColor =
                UIColor(AppTheme.Colors.iconInactive)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes =
                [.foregroundColor: UIColor(AppTheme.Colors.iconInactive)]
 
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject private var appState: AppState
    @State private var isEditing = false
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var username = ""
    @State private var year = ""
    @State private var major = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CommonPageHeader(title: "Profile")
                Form {
                    Section("My Information") {
                        if let user = appState.currentUser {
                            Text("Email: \(user.email)")
                            if !isEditing {
                                Text("Name: \(user.firstName) \(user.lastName)")
                                Text("Username: \(user.username)")
                                Text("Year: \(user.year)")
                                Text("Degrees: \(user.degrees.joined(separator: ", "))")
                                Text("Major: \(user.major ?? "-")")
                            } else {
                                TextField("First Name", text: $firstName)
                                TextField("Last Name", text: $lastName)
                                TextField("Username", text: $username)
                                TextField("Year", text: $year)
                                TextField("Major (Optional)", text: $major)
                            }
                        }
                    }
                    Section {
                        if isEditing {
                            Button("Save") {
                                guard var u = appState.currentUser else { return }
                                u.firstName = firstName
                                u.lastName = lastName
                                u.username = username
                                u.year = year
                                u.major = major.isEmpty ? nil : major
                                appState.currentUser = u
                                isEditing = false
                            }
                            .foregroundStyle(AppTheme.Colors.primary)
                            Button("Cancel", role: .cancel) { isEditing = false }
                        } else {
                            Button("Edit Profile") {
                                if let u = appState.currentUser {
                                    firstName = u.firstName
                                    lastName = u.lastName
                                    username = u.username
                                    year = u.year
                                    major = u.major ?? ""
                                }
                                isEditing = true
                            }
                            .foregroundStyle(AppTheme.Colors.primary)
                        }
                        Button("Log out", role: .destructive) {
                            appState.logout()
                        }
                    }
                }
            }
            .background(AppTheme.Colors.background)
            .navigationBarHidden(true)
        }
    }
}
