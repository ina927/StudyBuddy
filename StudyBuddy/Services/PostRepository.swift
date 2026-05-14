//
//  PostRepository.swift
//  StudyBuddy
//
//  Created by Ina Song on 14/5/2026.
//

import Foundation
import FirebaseFirestore

protocol PostRepositoryProtocol {
    func loadPosts() async throws -> [StudyPost]
    func savePost(_ post: StudyPost, onError: @escaping (String) -> Void)
    func deletePost(_ postID: String, onError: @escaping (String) -> Void)
}

final class PostRepository: PostRepositoryProtocol {
    private let database = Firestore.firestore()

    func loadPosts() async throws -> [StudyPost] {
        let snapshot = try await database.collection(FirestorePath.posts).getDocuments()
        return snapshot.documents.compactMap { doc in
            StudyPost.convertModel(
                id: doc.documentID,
                data: doc.data(),
                fallbackFloorPlanAssetNameProvider: { buildingCode, floor in
                    guard
                        let building = MetadataStore.buildings.first(where: { $0.code == buildingCode }),
                        let floorData = building.floors.first(where: { $0.name == floor })
                    else { return "Building 2 level 6" }
                    return floorData.floorPlanAssetName
                }
            )
        }
    }

    func savePost(_ post: StudyPost, onError: @escaping (String) -> Void) {
        database.collection(FirestorePath.posts).document(post.id).setData(post.convertFirestore()) { error in
            if let error {
                onError(error.localizedDescription)
            }
        }
    }

    func deletePost(_ postID: String, onError: @escaping (String) -> Void) {
        database.collection(FirestorePath.posts).document(postID).delete { error in
            if let error {
                onError(error.localizedDescription)
            }
        }
    }
}
