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
    @State private var profileImage: UIImage?

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                CommonPageHeader(title: "Profile")
                ZStack {
                           if let pic = appState.currentUser?.profilePic, let url = URL(string: pic), profileImage == nil {
                               AsyncImage(url: url) { image in
                                   image
                                       .resizable()
                                       .scaledToFill()
                               } placeholder: {
                                   Circle().fill(Color.purple.opacity(0.2))
                               }
                               .frame(width: 120, height: 120)
                               .clipShape(Circle())
                           }

                           ImagePickerView(selectedImage: $profileImage)
                               .frame(width: 120, height: 120)
                               .clipShape(Circle())
                               .opacity(profileImage != nil ? 1 : (appState.currentUser?.profilePic == nil ? 1 : 0.01))
                       }
                       .frame(width: 120, height: 120)
                       .onChange(of: profileImage) {
                           guard let image = profileImage, let user = appState.currentUser else { return }
                           Task {
                               if let url = await appState.uploadImage(image, identifier: user.id, folder: "profile") {
                                   var updated = user
                                   updated.profilePic = url
                                   appState.saveUser(updated)
                                   await MainActor.run {
                                       appState.currentUser = updated
                                   }
                               }
                           }
                       }
                
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
                        }

                        Button("Log out", role: .destructive) {
                            appState.logout()
                        }
                    }
                }
            }
        }
    }
}
