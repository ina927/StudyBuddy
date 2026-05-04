//
//  SignUpView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState

    @State private var email = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var username = ""
    @State private var year = "Year 1"
    @State private var major = ""

    @State private var selectedDegrees: [String] = []
    @State private var degreeSelection = ""

    @State private var emailTouched = false

    private var emailValid: Bool {
        let e = email.lowercased()
        let formatOK = e.contains("@") && e.contains(".")
        let domainOK = e.hasSuffix("@uts.edu.au") || e.hasSuffix("@student.uts.edu.au")
        return formatOK && domainOK
    }

    private var canCreate: Bool {
        emailValid &&
        !password.isEmpty &&
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        !username.isEmpty &&
        !selectedDegrees.isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Required") {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 4) {
                            Text("Student Email")
                            Text("*").foregroundStyle(.red)
                        }

                        TextField("name@uts.edu.au", text: $email)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .onChange(of: email) {
                                emailTouched = true
                            }
                        if emailTouched && !emailValid {
                            Text("Please use a valid student email (@uts.edu.au or @student.uts.edu.au).")
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }

                    SecureField("Password *", text: $password)
                    TextField("First Name *", text: $firstName)
                    TextField("Last Name *", text: $lastName)
                    TextField("Username *", text: $username)

                    Picker("Year *", selection: $year) {
                        Text("Year 1").tag("Year 1")
                        Text("Year 2").tag("Year 2")
                        Text("Year 3").tag("Year 3")
                        Text("Year 4+").tag("Year 4+")
                    }
                }

                Section("Degree *") {
                    MultiSelectDropdown(
                        placeholder: "Search degree",
                        options: MetadataStore.degrees.map(\.title),
                        selectedItems: $selectedDegrees,
                        maxSelection: 4
                    )
                }

                Section("Major (Optional)") {
                    TextField("Major", text: $major)
                }
            }
            .navigationTitle("Sign Up")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Create") {
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

                        appState.signUp(profile: profile)
                        dismiss()
                    }
                    .disabled(!canCreate)
                }
            }
        }
    }
}
