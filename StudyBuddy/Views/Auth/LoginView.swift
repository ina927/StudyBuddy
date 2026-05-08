//
//  LoginView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var appState: AppState

    @State private var email = ""
    @State private var password = ""
    @State private var showError = false

    private var canLogin: Bool {
        !email.isEmpty && !password.isEmpty
    }

    var body: some View {
        VStack(spacing: 12) {
            TextField("Student email", text: $email)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            if showError {
                Text("Please enter email and password.")
                    .font(.caption)
                    .foregroundStyle(.red)
            }

            Button("Log in") {
                guard canLogin else {
                    showError = true
                    return
                }
                
                Task {
                    await appState.login(email: email, password: password)
                }
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
        }
    }
}
