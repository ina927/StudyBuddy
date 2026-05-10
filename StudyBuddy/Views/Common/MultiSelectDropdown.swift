//
//  MultiSelectDropdown.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI

struct MultiSelectDropdown: View {
    let placeholder: String
    let options: [String]
    @Binding var selectedItems: [String]
    let maxSelection: Int

    @State private var isExpanded = false
    @State private var searchText = ""
    @State private var errorText: String?

    private var filteredOptions: [String] {
        if searchText.isEmpty { return options }
        return options.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                TextField(placeholder, text: $searchText)
                    .font(AppTheme.Typography.bodyMedium)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundStyle(AppTheme.Colors.textTertiary)
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.vertical, AppTheme.Spacing.sm)
            .background(AppTheme.Colors.surface)
            .cornerRadius(AppTheme.Radius.md)
            .contentShape(Rectangle())
            .onTapGesture {
                if !isExpanded {
                    withAnimation { isExpanded = true }
                }
            }

            if isExpanded {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(filteredOptions.prefix(12), id: \.self) { option in
                            Button {
                                if selectedItems.contains(option) {
                                    errorText = "Already selected."
                                    withAnimation { isExpanded = false }
                                    return
                                }
                                if selectedItems.count >= maxSelection {
                                    errorText = "Up to \(maxSelection) items."
                                    withAnimation { isExpanded = false }
                                    return
                                }
                                selectedItems.append(option)
                                errorText = nil
                                searchText = ""
                                withAnimation { isExpanded = false }
                            } label: {
                                HStack {
                                    Text(option)
                                        .font(AppTheme.Typography.bodyMedium)
                                        .foregroundStyle(AppTheme.Colors.textPrimary)
                                    Spacer()
                                    if selectedItems.contains(option) {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(AppTheme.Colors.primary)
                                    }
                                }
                                .padding(.horizontal, AppTheme.Spacing.md)
                                .padding(.vertical, AppTheme.Spacing.sm)
                            }
                            .buttonStyle(.plain)

                            Divider()
                                .background(AppTheme.Colors.divider)
                        }
                    }
                }
                .frame(maxHeight: 220)
                .background(AppTheme.Colors.surface)
                .cornerRadius(AppTheme.Radius.md)
            }

            if let errorText {
                Text(errorText)
                    .font(AppTheme.Typography.bodySmall)
                    .foregroundStyle(.red)
            }

            if !selectedItems.isEmpty {
                VStack(spacing: 6) {
                    ForEach(selectedItems, id: \.self) { item in
                        HStack {
                            Text(item)
                                .font(AppTheme.Typography.bodySmall)
                                .foregroundStyle(AppTheme.Colors.textSecondary)
                            Spacer()
                            Button {
                                selectedItems.removeAll { $0 == item }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(AppTheme.Colors.primary)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, AppTheme.Spacing.sm)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.12))
                        .cornerRadius(AppTheme.Radius.sm)
                    }
                }
            }
        }
    }
}
