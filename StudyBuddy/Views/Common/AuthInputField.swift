//
//  AuthInputField.swift
//  StudyBuddy
//
//  Created by Zizhu on 9/5/2026.
//
import SwiftUI

struct AuthInputField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(AppTheme.Colors.textTertiary)
                .frame(width: 20)
            if isSecure {
                SecureField(placeholder, text: $text)
                    .font(AppTheme.Typography.bodyMedium)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .font(AppTheme.Typography.bodyMedium)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(AppTheme.Colors.inputBg)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
