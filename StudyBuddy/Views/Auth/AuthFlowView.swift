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
            ZStack {
                AppTheme.Colors.primaryPale.ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()

                    VStack(spacing: 16) {
                        StudyBuddyLogo(size: 100)

                        Text("StudyBuddy")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundStyle(Color.black)

                        Text("Find your study buddy!")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    VStack(spacing: 14) {
                        NavigationLink(destination: LoginDetailView()) {
                            Text("Login")
                                .font(.body.weight(.semibold))
                                .foregroundStyle(AppTheme.Colors.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 17)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(AppTheme.Colors.primary, lineWidth: 1.5)
                                )
                        }
                        .buttonStyle(.plain)

                        Button {
                            showSignUp = true
                        } label: {
                            Text("Create account")
                                .font(.body.weight(.semibold))
                                .foregroundStyle(AppTheme.Colors.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 17)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(AppTheme.Colors.primary, lineWidth: 1.5)
                                )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 50)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showSignUp) {
                SignUpView()
            }
        }
    }
}
