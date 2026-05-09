//
//  EditPostView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI

struct EditPostView: View {
    @Binding var post: StudyPost
    @Environment(\.dismiss) private var dismiss
 
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()
 
                ScrollView {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
 
                        // ── Title ─────────────────────────────────────────
                        PostFormLabel(text: "Title", required: true)
 
                        TextField("Title", text: $post.title)
                            .font(AppTheme.Typography.bodyMedium)
                            .foregroundStyle(AppTheme.Colors.textPrimary)
                            .padding(AppTheme.Spacing.md)
                            .background(AppTheme.Colors.inputBg)
                            .cornerRadius(AppTheme.Radius.lg)
 
                        // ── Description ───────────────────────────────────
                        PostFormLabel(text: "Post Body", required: false)
 
                        TextField("What are you looking for?",
                                  text: $post.bodyText, axis: .vertical)
                            .font(AppTheme.Typography.bodyMedium)
                            .foregroundStyle(AppTheme.Colors.textPrimary)
                            .lineLimit(5, reservesSpace: true)
                            .padding(AppTheme.Spacing.md)
                            .background(AppTheme.Colors.inputBg)
                            .cornerRadius(AppTheme.Radius.lg)
 
                        // ── Study Period ──────────────────────────────────
                        PostFormLabel(text: "Study Period", required: true)
 
                        HStack(spacing: AppTheme.Spacing.sm) {
                            // Start
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Start")
                                    .font(AppTheme.Typography.labelSmall)
                                    .foregroundStyle(AppTheme.Colors.textTertiary)
                                DatePicker("", selection: $post.startTime,
                                           displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            }
                            .padding(AppTheme.Spacing.md)
                            .frame(maxWidth: .infinity)
                            .background(AppTheme.Colors.inputBg)
                            .cornerRadius(AppTheme.Radius.lg)
 
                            // End
                            VStack(alignment: .leading, spacing: 4) {
                                Text("End")
                                    .font(AppTheme.Typography.labelSmall)
                                    .foregroundStyle(AppTheme.Colors.textTertiary)
                                DatePicker("", selection: $post.endTime,
                                           displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            }
                            .padding(AppTheme.Spacing.md)
                            .frame(maxWidth: .infinity)
                            .background(AppTheme.Colors.inputBg)
                            .cornerRadius(AppTheme.Radius.lg)
                        }
 
                        if post.endTime <= post.startTime {
                            Text("End time must be after start time.")
                                .font(AppTheme.Typography.bodySmall)
                                .foregroundStyle(AppTheme.Colors.locationText)
                        }
 
                        // ── Capacity ──────────────────────────────────────
                        PostFormLabel(text: "Capacity", required: true)
 
                        HStack {
                            // Minus button
                            Button {
                                if post.capacity > 1 { post.capacity -= 1 }
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
                                Text("\(post.capacity)")
                                    .font(AppTheme.Typography.heading2)
                                    .foregroundStyle(AppTheme.Colors.textPrimary)
                                Text("people")
                                    .font(AppTheme.Typography.bodySmall)
                                    .foregroundStyle(AppTheme.Colors.textTertiary)
                            }
 
                            Spacer()
 
                            // Plus button
                            Button {
                                if post.capacity < 20 { post.capacity += 1 }
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
 
                        // ── Save button ───────────────────────────────────
                        Button { dismiss() } label: {
                            Text("Save Changes")
                                .font(AppTheme.Typography.label.weight(.semibold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, AppTheme.Spacing.sm)
                                .background(AppTheme.Colors.primary)
                                .cornerRadius(AppTheme.Radius.pill)
                        }
                        .padding(.top, AppTheme.Spacing.xs)
                    }
                    .padding(AppTheme.Spacing.md)
                }
            }
            .navigationTitle("Edit Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(AppTheme.Typography.label.weight(.semibold))
                        .foregroundStyle(AppTheme.Colors.primary)
                }
            }
        }
    }
}
