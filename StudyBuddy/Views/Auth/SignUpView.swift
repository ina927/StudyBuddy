//
//  SignUpView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss

    @State private var username       = ""
    @State private var email          = ""
    @State private var password       = ""
    @State private var firstName      = ""
    @State private var lastName       = ""
    @State private var year           = "Year 1"
    @State private var major          = ""
    @State private var selectedDegrees: [String] = []
    @State private var emailTouched   = false

    private var emailValid: Bool {
        let e = email.lowercased()
        return (e.hasSuffix("@uts.edu.au") || e.hasSuffix("@student.uts.edu.au")) && e.contains("@")
    }

    private var canCreate: Bool {
        emailValid && !password.isEmpty && !firstName.isEmpty &&
        !lastName.isEmpty && !username.isEmpty && !selectedDegrees.isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        HStack(spacing: 12) {
                            AuthInputField(icon: "person", placeholder: "First name", text: $firstName)
                            AuthInputField(icon: "person", placeholder: "Last name",  text: $lastName)
                        }

                        AuthInputField(icon: "at", placeholder: "Username", text: $username)

                        VStack(alignment: .leading, spacing: 6) {
                            AuthInputField(icon: "envelope", placeholder: "University email", text: $email, keyboardType: .emailAddress)
                            if emailTouched && !emailValid {
                                Text("Use your @uts.edu.au or @student.uts.edu.au email")
                                    .font(.caption)
                                    .foregroundStyle(.red)
                            }
                        }
                        .onChange(of: email) { _, _ in emailTouched = true }

                        AuthInputField(icon: "lock", placeholder: "Password", text: $password, isSecure: true)

                        VStack(alignment: .leading, spacing: 8) {
                            Label("Degree", systemImage: "graduationcap")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            MultiSelectDropdown(
                                placeholder: "Search degree",
                                options: MetadataStore.degrees.map(\.title),
                                selectedItems: $selectedDegrees,
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
                            emailTouched = true
                            guard canCreate else { return }
                            let profile = UserProfile(
                                id: UUID().uuidString,
                                email: email,
                                firstName: firstName,
                                lastName: lastName,
                                username: username,
                                degrees: selectedDegrees,
                                year: year,
                                major: major.isEmpty ? nil : major
                            )
                            Task {
                                await appState.signUp(email: email, password: password, profile: profile)
                                await MainActor.run {
                                    if appState.isAuthenticated {
                                        dismiss()
                                    }
                                }
                            }
                        } label: {
                            Text("Create account")
                                .font(.body.weight(.semibold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 17)
                                .background(canCreate ? AppTheme.Colors.primary : AppTheme.Colors.primary.opacity(0.4))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }

                        Button { dismiss() } label: {
                            HStack(spacing: 4) {
                                Text("Already have an account?")
                                    .foregroundStyle(.secondary)
                                Text("Login")
                                    .foregroundStyle(AppTheme.Colors.primary)
                                    .fontWeight(.semibold)
                            }
                            .font(.subheadline)
                        }
                        .buttonStyle(.plain)
                        .padding(.bottom, 16)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                }
            }
            .navigationTitle("Create account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
