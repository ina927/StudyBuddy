//
//  AuthService.swift
//  StudyBuddy
//
//  Created by Ina Song on 14/5/2026.
//

import Foundation
import FirebaseAuth

protocol AuthServiceProtocol {
    func createUser(email: String, password: String) async throws -> String
    func signIn(email: String, password: String) async throws -> String
    func signOut() throws
    func currentUserID() -> String?
}

struct AuthService: AuthServiceProtocol {
    func createUser(email: String, password: String) async throws -> String {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        return result.user.uid
    }

    func signIn(email: String, password: String) async throws -> String {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user.uid
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    func currentUserID() -> String? {
        Auth.auth().currentUser?.uid
    }
}
