//
//  UIState.swift
//  StudyBuddy
//
//  Created by Ina Song on 14/5/2026.
//

import Foundation

enum UIState: Equatable {
    case idle
    case loading
    case success(String)
    case failure(UserFacingError)
}

enum UserFacingError: Error, Equatable {
    case auth(String)
    case network(String)
    case firestore(String)
    case storage(String)
    case location(String)
    case unknown(String)

    var userMessage: String {
        switch self {
        case .auth(let msg),
             .network(let msg),
             .firestore(let msg),
             .storage(let msg),
             .location(let msg),
             .unknown(let msg):
            return msg
        }
    }

    var debugMessage: String {
        userMessage
    }
}
