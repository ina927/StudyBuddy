//
//  ImagePickerView.swift
//  StudyBuddy
//
//  Created by Kenneth Libarnes on 9/5/2026.
//

import SwiftUI

struct ImagePickerView: View {
    @Binding var selectedImage: UIImage?
    @State private var showOptions = false
    @State private var showCamera = false
    @State private var showLibrary = false

    var body: some View {
        Button {
            showOptions = true
        } label: {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
                    .frame(height: 200)
                    .overlay {
                        VStack(spacing: 8) {
                            Image(systemName: "camera.fill")
                                .font(.largeTitle)
                            Text("Add a photo")
                                .font(.subheadline)
                        }
                        .foregroundStyle(.secondary)
                    }
            }
        }
        .confirmationDialog("Add a photo", isPresented: $showOptions, titleVisibility: .visible) {
            Button("Take a photo") { showCamera = true }
            Button("Choose from library") { showLibrary = true }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showCamera) {
            CameraView(image: $selectedImage, sourceType: .camera)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showLibrary) {
            CameraView(image: $selectedImage, sourceType: .photoLibrary)
                .ignoresSafeArea()
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    let sourceType: UIImagePickerController.SourceType
    @Environment(\.dismiss) var dismiss

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerController.isSourceTypeAvailable(sourceType) ? sourceType : .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
