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
    @State private var inputText = ""
    @State private var errorText: String?

    private var filteredOptions: [String] {
        if inputText.isEmpty { return options }
        return options.filter { $0.localizedCaseInsensitiveContains(inputText) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                TextField(placeholder, text: $inputText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .onTapGesture { isExpanded = true }
                    .onChange(of: inputText) {
                        isExpanded = true
                        errorText = nil
                    }

                Button {
                    withAnimation { isExpanded.toggle() }
                } label: {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))

            if isExpanded {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(filteredOptions.prefix(8), id: \.self) { option in
                            Button {
                                guard selectedItems.count < maxSelection else {
                                    errorText = "Up to \(maxSelection) items."
                                    return
                                }

                                if !selectedItems.contains(option) {
                                    selectedItems.append(option)
                                } else {
                                    errorText = "Already selected."
                                    return
                                }

                                inputText = ""
                                isExpanded = false
                                errorText = nil
                            } label: {
                                HStack {
                                    Text(option)
                                    Spacer()
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)

                            Divider()
                        }
                    }
                }
                .frame(maxHeight: 220)
                .background(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.separator), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
            }

            if let errorText {
                Text(errorText)
                    .font(.caption)
                    .foregroundStyle(.red)
            }

            if !selectedItems.isEmpty {
                VStack(spacing: 6) {
                    ForEach(selectedItems, id: \.self) { item in
                        HStack {
                            Text(item)
                                .font(.subheadline)
                            Spacer()
                            Button {
                                selectedItems.removeAll { $0 == item }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }
}
