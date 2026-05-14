//
//  ImageStorageService.swift
//  StudyBuddy
//
//  Created by Ina Song on 14/5/2026.
//

import Foundation
import FirebaseStorage
import UIKit

/// Handles image uploads to Firebase Storage
protocol ImageStorageServiceProtocol {
    func uploadImage(_ image: UIImage, identifier: String, folder: String) async -> String?
}

struct ImageStorageService: ImageStorageServiceProtocol {
    func uploadImage(_ image: UIImage, identifier: String, folder: String) async -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else { return nil }

        let ref = Storage.storage().reference().child("\(folder)/\(identifier).jpg")

        do {
            _ = try await ref.putDataAsync(imageData)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            return nil
        }
    }
}
