//
//  AppState.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//
import Combine
import Foundation

final class AppState: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: UserProfile?
    @Published var posts: [StudyPost] = DemoPosts.seed
    @Published var selectedTab: Int = 0 // 0 feed, 1 create, 2 profile

    func login(email: String, username: String) {
        currentUser = UserProfile(
            id: UUID().uuidString,
            email: email,
            firstName: "",
            lastName: "",
            username: username,
            degrees: [],
            year: "",
            major: nil
        )
        isAuthenticated = true
    }

    func signUp(profile: UserProfile) {
        currentUser = profile
        isAuthenticated = true
    }

    func logout() {
        currentUser = nil
        isAuthenticated = false
        selectedTab = 0
    }

    func addPost(from draft: CreatePostDraft) {
        guard let user = currentUser else { return }

        let post = StudyPost(
            id: UUID().uuidString,
            hostUserID: user.id,
            hostUsername: user.username,
            hostYear: user.year,
            hostDegrees: user.degrees,
            hostMajor: user.major,
            title: draft.title,
            bodyText: draft.postBody,
            buildingCode: draft.buildingCode,
            buildingName: draft.buildingName,
            floor: draft.floor,
            locationDescription: draft.locationDescription,
            photoAssetName: draft.photoAssetName,
            subjects: draft.subjects,
            vibe: draft.vibe,
            capacity: draft.capacity,
            startTime: draft.startTime,
            endTime: draft.endTime,
            createdAt: Date(),
            statusOverride: nil
        )

        posts.insert(post, at: 0)
        selectedTab = 0 // go to feed after posting
    }

    func updatePost(_ post: StudyPost) {
        guard let idx = posts.firstIndex(where: { $0.id == post.id }) else { return }
        posts[idx] = post
    }

    func deletePost(_ post: StudyPost) {
        posts.removeAll { $0.id == post.id }
    }
}
