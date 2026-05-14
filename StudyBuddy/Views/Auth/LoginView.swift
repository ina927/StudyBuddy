//
//  LoginView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI

struct LoginDetailView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var email        = ""
    @State private var password     = ""
    @State private var showPassword = false
    @State private var showSignUp   = false
    @State private var showError    = false
    @State private var errorMessage = ""

    private var canLogin: Bool { !email.isEmpty && !password.isEmpty }

    var body: some View {
        ZStack(alignment: .top) {
            AppTheme.Colors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                // Purple header
                VStack(spacing: 10) {
                    StudyBuddyLogo(size: 64, isMonochrome: true)
                    Text("StudyBuddy")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                    Text("Find your study buddy!")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))
                    Spacer().frame(height: 16)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 24)
                .background(AppTheme.Colors.primary)

                // Form
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("University Email")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        AuthInputField(icon: "envelope", placeholder: "", text: $email, keyboardType: .emailAddress)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Password")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        AuthInputField(icon: "lock", placeholder: "", text: $password, isSecure: !showPassword)
                    }

                    HStack {
                        Spacer()
                        Button("Forgot password?") { }
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.Colors.primary)
                    }

                    if showError {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .padding(.vertical, 4)
                    }

                    Button {
                        guard canLogin else {
                            errorMessage = "Please enter your email and password."
                            showError = true
                            return
                        }
                        Task {
                            await appState.login(email: email, password: password)
                            
                            // Check if login failed
                            if case .failure(let error) = appState.uiState {
                                errorMessage = error.userMessage
                                showError = true
                            }
                        }
                    } label: {
                        Text("Login")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 17)
                            .background(canLogin ? AppTheme.Colors.primary : AppTheme.Colors.primary.opacity(0.4))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .disabled(appState.isLoading)
                }
                .padding(24)

                Spacer()

                HStack(spacing: 4) {
                    Text("You don't have an account?")
                        .foregroundStyle(.secondary)
                    Button("Sign up") { showSignUp = true }
                        .foregroundStyle(AppTheme.Colors.primary)
                        .fontWeight(.semibold)
                }
                .font(.subheadline)
                .padding(.bottom, 30)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .sheet(isPresented: $showSignUp) {
            SignUpView()
        }
    }
}

// Keep LoginView as a typealias so nothing else breaks
typealias LoginView = LoginDetailView
