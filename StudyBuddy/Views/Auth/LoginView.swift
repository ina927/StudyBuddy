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

    @State private var email    = ""
    @State private var password = ""
    @State private var showError = false

    private var canLogin: Bool { !email.isEmpty && !password.isEmpty }

    var body: some View {
        ZStack {
            AppTheme.pageBg.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                VStack(spacing: 14) {
                    AuthInputField(icon: "envelope", placeholder: "University email", text: $email, keyboardType: .emailAddress)
                    AuthInputField(icon: "lock", placeholder: "Password", text: $password, isSecure: true)

                    if showError {
                        Text("Please enter your email and password.")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }

                Button {
                    guard canLogin else { showError = true; return }
                    Task {
                        await appState.login(email: email, password: password)
                    }
                } label: {
                    Text("Login")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .background(canLogin ? AppTheme.accentPurple : AppTheme.accentPurple.opacity(0.4))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                Spacer()

                NavigationLink(destination: SignUpView()) {
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .foregroundStyle(.secondary)
                        Text("Create account")
                            .foregroundStyle(AppTheme.accentPurple)
                            .fontWeight(.semibold)
                    }
                    .font(.subheadline)
                }
                .buttonStyle(.plain)
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle("Login")
        .navigationBarTitleDisplayMode(.inline)
    }
}
