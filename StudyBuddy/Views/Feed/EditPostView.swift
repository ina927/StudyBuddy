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
            Form {
                TextField("Title", text: $post.title)
                TextField("Post Body", text: $post.bodyText, axis: .vertical)
                DatePicker("Start", selection: $post.startTime)
                DatePicker("End", selection: $post.endTime)
                Stepper("Capacity: \(post.capacity)", value: $post.capacity, in: 1...20)
            }
            .navigationTitle("Edit Post")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
