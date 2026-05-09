//
//  PostDetailsView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI

struct PostDetailsView: View {
    @EnvironmentObject private var appState: AppState
    @Binding var draft: CreatePostDraft
    let onPosted: () -> Void
 
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
 
                // ── Location (read-only) ──────────────────────────────────
                PostFormLabel(text: "Location", required: true)
 
                HStack(spacing: AppTheme.Spacing.sm) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(AppTheme.Colors.locationText)
                    Text(draft.locationDescription.isEmpty
                         ? "Click to set location..."
                         : "\(draft.buildingCode) \(draft.floor) · \(draft.locationDescription)")
                        .font(AppTheme.Typography.bodyMedium)
                        .foregroundStyle(draft.locationDescription.isEmpty
                            ? AppTheme.Colors.textTertiary
                            : AppTheme.Colors.textPrimary)
                    Spacer()
                }
                .padding(AppTheme.Spacing.md)
                .frame(minHeight: 52)
                .background(AppTheme.Colors.inputBg)
                .cornerRadius(AppTheme.Radius.lg)
 
                // ── Title ─────────────────────────────────────────────────
                PostFormLabel(text: "Title", required: true)
 
                TextField("Looking for ML study partner!!", text: $draft.title)
                    .font(AppTheme.Typography.bodyMedium)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                    .padding(AppTheme.Spacing.md)
                    .background(AppTheme.Colors.inputBg)
                    .cornerRadius(AppTheme.Radius.lg)
 
                // ── Description ───────────────────────────────────────────
                PostFormLabel(text: "Description", required: false)
 
                TextField("What are you looking for?",
                          text: $draft.postBody, axis: .vertical)
                    .font(AppTheme.Typography.bodyMedium)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                    .lineLimit(5, reservesSpace: true)
                    .padding(AppTheme.Spacing.md)
                    .background(AppTheme.Colors.inputBg)
                    .cornerRadius(AppTheme.Radius.lg)
 
                // ── Subject Code ──────────────────────────────────────────
                PostFormLabel(text: "Subject Code", required: true)
 
                SubjectCodeField(selectedSubjects: $draft.subjects)
 
                // ── Study Period ──────────────────────────────────────────
                PostFormLabel(text: "Study Period", required: true)
 
                HStack(spacing: AppTheme.Spacing.sm) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Start time")
                            .font(AppTheme.Typography.labelSmall)
                            .foregroundStyle(AppTheme.Colors.textTertiary)
                        DatePicker("", selection: $draft.startTime,
                                   displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    .padding(AppTheme.Spacing.md)
                    .frame(maxWidth: .infinity)
                    .background(AppTheme.Colors.inputBg)
                    .cornerRadius(AppTheme.Radius.lg)
 
                    VStack(alignment: .leading, spacing: 4) {
                        Text("End time")
                            .font(AppTheme.Typography.labelSmall)
                            .foregroundStyle(AppTheme.Colors.textTertiary)
                        DatePicker("", selection: $draft.endTime,
                                   displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    .padding(AppTheme.Spacing.md)
                    .frame(maxWidth: .infinity)
                    .background(AppTheme.Colors.inputBg)
                    .cornerRadius(AppTheme.Radius.lg)
                }
 
                if draft.endTime <= draft.startTime {
                    Text("End time must be after start time.")
                        .font(AppTheme.Typography.bodySmall)
                        .foregroundStyle(AppTheme.Colors.locationText)
                }
 
                // ── Vibe ──────────────────────────────────────────────────
                PostFormLabel(text: "Vibe", required: false)
 
                LazyVGrid(
                    columns: [GridItem(.flexible()), GridItem(.flexible())],
                    spacing: AppTheme.Spacing.sm
                ) {
                    ForEach(MetadataStore.vibes, id: \.self) { vibe in
                        Button { draft.vibe = vibe } label: {
                            Text(vibe)
                                .font(AppTheme.Typography.label)
                                .foregroundStyle(draft.vibe == vibe
                                    ? .white
                                    : AppTheme.Colors.textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, AppTheme.Spacing.sm)
                                .background(draft.vibe == vibe
                                    ? AppTheme.Colors.primary
                                    : AppTheme.Colors.inputBg)
                                .cornerRadius(AppTheme.Radius.lg)
                        }
                    }
                }
 
                // ── Capacity ──────────────────────────────────────────────
                PostFormLabel(text: "Capacity", required: true)
 
                HStack {
                    Button {
                        if draft.capacity > 1 { draft.capacity -= 1 }
                    } label: {
                        Image(systemName: "minus")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(AppTheme.Colors.primary)
                            .frame(width: 36, height: 36)
                            .background(AppTheme.Colors.primaryPale)
                            .cornerRadius(AppTheme.Radius.pill)
                    }
 
                    Spacer()
 
                    VStack(spacing: 2) {
                        Text("\(draft.capacity)")
                            .font(AppTheme.Typography.heading2)
                            .foregroundStyle(AppTheme.Colors.textPrimary)
                        Text("people")
                            .font(AppTheme.Typography.bodySmall)
                            .foregroundStyle(AppTheme.Colors.textTertiary)
                    }
 
                    Spacer()
 
                    Button {
                        if draft.capacity < 20 { draft.capacity += 1 }
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(AppTheme.Colors.primary)
                            .frame(width: 36, height: 36)
                            .background(AppTheme.Colors.primaryPale)
                            .cornerRadius(AppTheme.Radius.pill)
                    }
                }
                .padding(AppTheme.Spacing.md)
                .background(AppTheme.Colors.inputBg)
                .cornerRadius(AppTheme.Radius.lg)
 
                // ── Post button ───────────────────────────────────────────
                Button {
                    appState.addPost(from: draft)
                    onPosted()
                } label: {
                    Text("Post")
                        .font(AppTheme.Typography.label.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.sm)
                        .background(draft.canPost
                            ? AppTheme.Colors.primary
                            : AppTheme.Colors.textTertiary)
                        .cornerRadius(AppTheme.Radius.pill)
                }
                .disabled(!draft.canPost)
                .padding(.top, AppTheme.Spacing.xs)
            }
            .padding(AppTheme.Spacing.md)
        }
        .background(AppTheme.Colors.background)
    }
}
 
// MARK: - Subject Code Field
private struct SubjectCodeField: View {
    @Binding var selectedSubjects: [String]
    @State private var inputText = ""
    @State private var isExpanded = false
 
    private var filtered: [String] {
        let opts = MetadataStore.subjects.map(\.label)
        if inputText.isEmpty { return opts }
        return opts.filter { $0.localizedCaseInsensitiveContains(inputText) }
    }
 
    var body: some View {
        VStack(spacing: AppTheme.Spacing.xs) {
 
            // Already selected — show with minus button
            ForEach(selectedSubjects, id: \.self) { subject in
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "book.closed")
                            .font(.system(size: 11))
                            .foregroundStyle(AppTheme.Colors.tagText)
                        Text(subject)
                            .font(AppTheme.Typography.bodyMedium)
                            .foregroundStyle(AppTheme.Colors.textPrimary)
                    }
                    Spacer()
                    Button {
                        selectedSubjects.removeAll { $0 == subject }
                    } label: {
                        Image(systemName: "minus")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(AppTheme.Colors.textSecondary)
                            .frame(width: 28, height: 28)
                            .background(AppTheme.Colors.surface)
                            .cornerRadius(AppTheme.Radius.pill)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.vertical, AppTheme.Spacing.sm)
                .background(AppTheme.Colors.inputBg)
                .cornerRadius(AppTheme.Radius.lg)
            }
 
            // Input row with + (max 3)
            if selectedSubjects.count < 3 {
                HStack {
                    TextField("e.g. 123057", text: $inputText)
                        .font(AppTheme.Typography.bodyMedium)
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                        .onTapGesture { isExpanded = true }
                        .onChange(of: inputText) { isExpanded = true }
 
                    Button {
                        let match = filtered.first(where: {
                            $0.localizedCaseInsensitiveContains(inputText)
                        }) ?? (inputText.isEmpty ? nil : inputText)
 
                        if let match, !selectedSubjects.contains(match) {
                            selectedSubjects.append(match)
                            inputText = ""
                            isExpanded = false
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(AppTheme.Colors.primary)
                            .frame(width: 28, height: 28)
                            .background(AppTheme.Colors.primaryPale)
                            .cornerRadius(AppTheme.Radius.pill)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.vertical, AppTheme.Spacing.sm)
                .background(AppTheme.Colors.inputBg)
                .cornerRadius(AppTheme.Radius.lg)
 
                // Dropdown suggestions
                if isExpanded && !filtered.isEmpty {
                    VStack(spacing: 0) {
                        ForEach(filtered.prefix(5), id: \.self) { option in
                            Button {
                                if !selectedSubjects.contains(option) {
                                    selectedSubjects.append(option)
                                }
                                inputText = ""
                                isExpanded = false
                            } label: {
                                HStack {
                                    Text(option)
                                        .font(AppTheme.Typography.bodyMedium)
                                        .foregroundStyle(AppTheme.Colors.textPrimary)
                                    Spacer()
                                }
                                .padding(.horizontal, AppTheme.Spacing.md)
                                .padding(.vertical, AppTheme.Spacing.sm)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
 
                            if option != filtered.prefix(5).last {
                                Divider()
                                    .background(AppTheme.Colors.divider)
                                    .padding(.horizontal, AppTheme.Spacing.md)
                            }
                        }
                    }
                    .background(AppTheme.Colors.surface)
                    .cornerRadius(AppTheme.Radius.md)
                    .shadow(color: AppTheme.Shadows.card.color,
                            radius: AppTheme.Shadows.card.radius,
                            x: AppTheme.Shadows.card.x,
                            y: AppTheme.Shadows.card.y)
                }
            }
        }
    }
}
 
// MARK: - Form label
struct PostFormLabel: View {
    let text: String
    let required: Bool
 
    var body: some View {
        HStack(spacing: 2) {
            Text(text)
                .font(AppTheme.Typography.label.weight(.semibold))
                .foregroundStyle(AppTheme.Colors.primary)
            if required {
                Text("*")
                    .font(AppTheme.Typography.label)
                    .foregroundStyle(AppTheme.Colors.locationText)
            }
        }
        .padding(.bottom, -AppTheme.Spacing.xs)
    }
}
