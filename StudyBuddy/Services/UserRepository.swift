//
//  UserRepository.swift
//  StudyBuddy
//
//  Created by Ina Song on 14/5/2026.
//

import Foundation
import FirebaseFirestore

protocol UserRepositoryProtocol {
    func saveUser(_ user: UserProfile, onError: @escaping (String) -> Void)
    func getUser(id: String) async -> UserProfile?
}

final class UserRepository: UserRepositoryProtocol {
    private let database = Firestore.firestore()

    func saveUser(_ user: UserProfile, onError: @escaping (String) -> Void) {
        database.collection("users").document(user.id).setData(user.convertFirestore()) { error in
            if let error {
                onError(error.localizedDescription)
            }
        }
    }

    func getUser(id: String) async -> UserProfile? {
        let doc = try? await database.collection("users").document(id).getDocument()
        guard let data = doc?.data() else { return nil }
        return UserProfile.convertModel(id: id, data: data)
    }
}
