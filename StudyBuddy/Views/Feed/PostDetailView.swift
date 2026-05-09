//
//  PostDetailView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI

struct PostDetailView: View {
    @EnvironmentObject private var appState: AppState
    @State var post: StudyPost
    @State private var showEdit = false

    private var isHost: Bool {
        return appState.currentUser?.id == post.hostUserID
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if let photo = post.photoAssetName, let url = URL(string: photo) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 130)
                            .clipped()
                    } placeholder: {
                        Rectangle()
                            .fill(Color.purple.opacity(0.25))
                            .frame(height: 130)
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(post.title).font(.title3.bold())
                        Spacer()
                        PostStatusBadge(status: post.computedStatus)
                    }

                    Text(post.bodyText).foregroundStyle(.secondary)

                    Label("\(post.buildingCode) \(post.floor) · \(post.locationDescription)", systemImage: "mappin.and.ellipse")
                    Label("\(post.startTime.formatted(date: .abbreviated, time: .shortened)) - \(post.endTime.formatted(date: .omitted, time: .shortened))", systemImage: "clock")
                    Label("Capacity \(post.capacity)", systemImage: "person.2")
                }
                .padding(.horizontal)

                if isHost {
                    Divider().padding(.horizontal)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Host Controls").font(.headline)
                        Picker("Status", selection: Binding(
                            get: { post.statusOverride ?? post.computedStatus },
                            set: { post.statusOverride = $0; appState.updatePost(post) }
                        )) {
                            Text("Not Started").tag(StudyPost.Status.notStarted)
                            Text("Ongoing").tag(StudyPost.Status.ongoing)
                            Text("Full").tag(StudyPost.Status.full)
                            Text("Finished").tag(StudyPost.Status.finished)
                        }
                        .pickerStyle(.menu)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Post Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if isHost {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Edit") { showEdit = true }
                        Button("Delete", role: .destructive) {
                            appState.deletePost(post)
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
        .sheet(isPresented: $showEdit) {
            EditPostView(post: $post)
                .onDisappear { appState.updatePost(post) }
        }
    }
}
