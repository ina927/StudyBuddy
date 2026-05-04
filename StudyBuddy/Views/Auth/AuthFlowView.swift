//
//  AuthFlowView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI

struct AuthFlowView: View {
    @State private var showSignUp = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("StudyBuddy")
                    .font(.largeTitle.bold())

                Text("Find study partners around campus")
                    .foregroundStyle(.secondary)

                LoginView()

                Button("Need an account? Sign up") {
                    showSignUp = true
                }
                .font(.footnote)
            }
            .padding()
            .sheet(isPresented: $showSignUp) {
                SignUpView()
            }
        }
    }
}
