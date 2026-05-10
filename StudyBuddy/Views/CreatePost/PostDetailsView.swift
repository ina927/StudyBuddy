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
    let onBackToLocation: () -> Void

    @State private var selectedDate = Calendar.current.startOfDay(for: Date())
    @State private var startTime = Date()
    @State private var endTime = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()

    private var normalizedStart: Date { merge(date: selectedDate, time: startTime) }
    private var normalizedEnd: Date { merge(date: selectedDate, time: endTime) }

    private var canPost: Bool {
        draft.canPost &&
        !draft.vibe.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        normalizedEnd > normalizedStart
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.md) {
                // Location button
                Button {
                    onBackToLocation()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "mappin.circle")
                            .font(.system(size: 16))
                        Text("\(draft.buildingCode) \(draft.floor) · \(draft.locationDescription)")
                            .font(AppTheme.Typography.bodyMedium)
                            .lineLimit(1)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundStyle(AppTheme.Colors.primary)
                    .padding(AppTheme.Spacing.md)
                    .frame(maxWidth: .infinity)
                    .background(AppTheme.Colors.surface)
                    .cornerRadius(AppTheme.Radius.md)
                }
                .buttonStyle(.plain)

                fieldBlock(title: "Title", required: true) {
                    TextField("Post title", text: $draft.title)
                        .font(AppTheme.Typography.bodyMedium)
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                        .padding(AppTheme.Spacing.md)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(AppTheme.Colors.surface)
                        .cornerRadius(AppTheme.Radius.md)
                }

                fieldBlock(title: "Post Body", required: true) {
                    TextField("Write your post...", text: $draft.postBody, axis: .vertical)
                        .font(AppTheme.Typography.bodyMedium)
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                        .lineLimit(4, reservesSpace: true)
                        .padding(AppTheme.Spacing.md)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(AppTheme.Colors.surface)
                        .cornerRadius(AppTheme.Radius.md)
                }

                fieldBlock(title: "Study Date", required: true) {
                    HStack {
                        DatePicker("Study Date", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                            .labelsHidden()
                            .font(AppTheme.Typography.bodyMedium)
                        Spacer()
                    }
                    .padding(AppTheme.Spacing.md)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(AppTheme.Colors.surface)
                    .cornerRadius(AppTheme.Radius.md)
                }

                fieldBlock(title: "Study Time", required: true) {
                    HStack(spacing: AppTheme.Spacing.md) {
                        HStack(spacing: 8) {
                            Text("Start")
                                .font(AppTheme.Typography.bodyMedium)
                                .foregroundStyle(AppTheme.Colors.textSecondary)
                            DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .font(AppTheme.Typography.bodyMedium)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 8) {
                            Text("End")
                                .font(AppTheme.Typography.bodyMedium)
                                .foregroundStyle(AppTheme.Colors.textSecondary)
                            DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .font(AppTheme.Typography.bodyMedium)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(AppTheme.Spacing.md)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(AppTheme.Colors.surface)
                    .cornerRadius(AppTheme.Radius.md)
                }

                if normalizedEnd <= normalizedStart {
                    Text("End time must be later than start time.")
                        .font(AppTheme.Typography.bodySmall)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                fieldBlock(title: "Vibe", required: true) {
                    HStack {
                        Picker("Vibe", selection: $draft.vibe) {
                            ForEach(MetadataStore.vibes, id: \.self) {
                                Text($0)
                                    .font(AppTheme.Typography.bodyMedium)
                                    .tag($0)
                            }
                        }
                        .pickerStyle(.menu)
                        .font(AppTheme.Typography.bodyMedium)
                        Spacer()
                    }
                    .padding(AppTheme.Spacing.md)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(AppTheme.Colors.surface)
                    .cornerRadius(AppTheme.Radius.md)
                }

                fieldBlock(title: "Subject", required: true) {
                    MultiSelectDropdown(
                        placeholder: "Search subject",
                        options: MetadataStore.subjects.map(\.label),
                        selectedItems: $draft.subjects,
                        maxSelection: 3
                    )
                    .frame(maxWidth: .infinity)
                }

                fieldBlock(title: "Capacity", required: true) {
                    Picker("Capacity", selection: $draft.capacity) {
                        ForEach(1...20, id: \.self) { v in
                            Text("\(v) people")
                                .font(AppTheme.Typography.bodyMedium)
                                .tag(v)
                        }
                    }
                    .pickerStyle(.wheel)
                    .font(AppTheme.Typography.bodyMedium)
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .background(AppTheme.Colors.surface)
                    .cornerRadius(AppTheme.Radius.md)
                }

                Button {
                    Task {
                        draft.startTime = normalizedStart
                        draft.endTime = normalizedEnd
                        await appState.addPost(from: draft)
                        onPosted()
                    }
                } label: {
                    Text("Post")
                        .font(AppTheme.Typography.label.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.md)
                        .background(canPost ? AppTheme.Colors.primary : AppTheme.Colors.textTertiary)
                        .cornerRadius(AppTheme.Radius.md)
                }
                .disabled(!canPost)
            }
            .padding(AppTheme.Spacing.md)
        }
        .onAppear {
            selectedDate = Calendar.current.startOfDay(for: Date())
        }
    }

    private func merge(date: Date, time: Date) -> Date {
        let cal = Calendar.current
        let d = cal.dateComponents([.year, .month, .day], from: date)
        let t = cal.dateComponents([.hour, .minute], from: time)
        return cal.date(from: DateComponents(year: d.year, month: d.month, day: d.day, hour: t.hour, minute: t.minute)) ?? date
    }

    private func fieldBlock<Content: View>(title: String, required: Bool, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            PostFormLabel(text: title, required: required)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

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
                    .font(AppTheme.Typography.label.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.locationText)
            }
        }
    }
}
