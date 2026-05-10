//
//  EditProfileView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var username = ""
    @State private var year = "Year 1"
    @State private var major = ""
    @State private var degrees: [String] = []

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Name", systemImage: "person")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            HStack(spacing: 12) {
                                AuthInputField(icon: "person", placeholder: "First name", text: $firstName)
                                AuthInputField(icon: "person", placeholder: "Last name", text: $lastName)
                            }
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Label("Username", systemImage: "at")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            AuthInputField(icon: "at", placeholder: "Username", text: $username)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Label("Degree", systemImage: "graduationcap")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            MultiSelectDropdown(
                                placeholder: "Search degree",
                                options: MetadataStore.degrees.map(\.title),
                                selectedItems: $degrees,
                                maxSelection: 4
                            )
                        }

                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Year", systemImage: "calendar")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Picker("Year", selection: $year) {
                                    ForEach(["Year 1", "Year 2", "Year 3", "Year 4+"], id: \.self) { 
                                        Text($0)
                                            .font(AppTheme.Typography.bodyMedium)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(AppTheme.Colors.textPrimary)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 14)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(AppTheme.Colors.inputBg)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Label("Major", systemImage: "book")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                AuthInputField(icon: "book.closed", placeholder: "Optional", text: $major)
                            }
                        }

                        Button {
                            guard var user = appState.currentUser else { return }
                            user.firstName = firstName
                            user.lastName = lastName
                            user.username = username.isEmpty ? user.username : username
                            user.year = year
                            user.major = major.isEmpty ? nil : major
                            user.degrees = degrees
                            appState.currentUser = user
                            appState.saveUser(user)
                            dismiss()
                        } label: {
                            Text("Save")
                                .font(.body.weight(.semibold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 17)
                                .background(AppTheme.Colors.primary)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                guard let user = appState.currentUser else { return }
                firstName = user.firstName
                lastName = user.lastName
                username = user.username
                year = user.year.isEmpty ? "Year 1" : user.year
                major = user.major ?? ""
                degrees = user.degrees
            }
        }
    }
}
