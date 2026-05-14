import CoreLocation
import FirebaseCore
import Combine
import UIKit

@MainActor
final class AppState: NSObject, ObservableObject {
    private let authService: AuthServiceProtocol
    private let userRepository: UserRepositoryProtocol
    private let postRepository: PostRepositoryProtocol
    private let imageStorageService: ImageStorageServiceProtocol
    private let locationService: LocationServiceProtocol

    @Published var isAuthenticated: Bool = false
    @Published var currentUser: UserProfile?
    @Published var posts: [StudyPost] = []
    @Published var selectedTab: Int = 0
    @Published var status: String = "Loading"
    @Published var currentLoc: CLLocation?
    @Published var isLoading = false

    @Published private(set) var uiState: UIState = .idle

    // MARK: - Initialization

    init(
        authService: AuthServiceProtocol,
        userRepository: UserRepositoryProtocol,
        postRepository: PostRepositoryProtocol,
        imageStorageService: ImageStorageServiceProtocol,
        locationService: LocationServiceProtocol
    ) {
        self.authService = authService
        self.userRepository = userRepository
        self.postRepository = postRepository
        self.imageStorageService = imageStorageService
        self.locationService = locationService
        super.init()

        self.locationService.onLocationUpdate = { [weak self] location in
            Task { @MainActor in
                self?.currentLoc = location
            }
        }

        self.locationService.onLocationError = { [weak self] error in
            Task { @MainActor in
                self?.setFailure(.location("Location failed: \(error.localizedDescription)"))
            }
        }

        self.locationService.onAuthorizationDenied = { [weak self] in
            Task { @MainActor in
                self?.setFailure(.location("Location permission denied"))
            }
        }
    }

    convenience override init() {
        self.init(
            authService: AuthService(),
            userRepository: UserRepository(),
            postRepository: PostRepository(),
            imageStorageService: ImageStorageService(),
            locationService: LocationService()
        )
    }

    // MARK: - UI State

    private func setLoading(_ message: String = "Loading") {
        uiState = .loading
        status = message
        isLoading = true
    }

    private func setSuccess(_ message: String) {
        uiState = .success(message)
        status = message
        isLoading = false
    }

    private func setFailure(_ error: UserFacingError) {
        uiState = .failure(error)
        status = error.userMessage
        isLoading = false
    }

    private func setFailure(_ message: String) {
        setFailure(.unknown(message))
    }

    // MARK: - Authentication

    func signUp(email: String, password: String, profile: UserProfile) async {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.isEmpty else {
            setFailure(.auth("Please enter your email and password."))
            return
        }
        setLoading("Signing up...")

        do {
            let uid = try await authService.createUser(email: email, password: password)

            let userWithID = UserProfile(
                id: uid,
                email: email,
                firstName: profile.firstName,
                lastName: profile.lastName,
                username: profile.username,
                degrees: profile.degrees,
                year: profile.year,
                major: profile.major,
                profilePic: profile.profilePic
            )

            saveUser(userWithID)

            currentUser = userWithID
            isAuthenticated = true

            await loadPosts()
            setSuccess("Signed up")
        } catch {
            setFailure(.auth("Sign up failed: \(error.localizedDescription)"))
        }
    }

    func login(email: String, password: String) async {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.isEmpty else {
            setFailure(.auth("Please enter your email and password."))
            return
        }
        setLoading("Logging in...")

        do {
            let uid = try await authService.signIn(email: email, password: password)
            guard let user = await userRepository.getUser(id: uid) else {
                setFailure(.auth("Login failed: user profile not found"))
                return
            }

            currentUser = user
            isAuthenticated = true

            await loadPosts()
            setSuccess("Logged in")
        } catch {
            setFailure(.auth("Login failed: \(error.localizedDescription)"))
        }
    }

    func logout() {
        do {
            try authService.signOut()
            currentUser = nil
            isAuthenticated = false
            selectedTab = 0
            posts = []
            setSuccess("Logged out")
        } catch {
            setFailure(.auth("Logout failed: \(error.localizedDescription)"))
        }
    }

    func checkSession() async {
        guard let uid = authService.currentUserID() else { return }
        guard let user = await userRepository.getUser(id: uid) else { return }

        currentUser = user
        isAuthenticated = true
        await loadPosts()
    }

    // MARK: - Image Upload

    func uploadImage(_ image: UIImage, identifier: String, folder: String) async -> String? {
        await imageStorageService.uploadImage(image, identifier: identifier, folder: folder)
    }

    // MARK: - Posts

    func loadPosts() async {
        do {
            posts = try await postRepository.loadPosts()
        } catch {
            setFailure(.firestore("Failed to load posts: \(error.localizedDescription)"))
        }
    }

    func addPost(from draft: CreatePostDraft) async {
        guard let user = currentUser else { return }

        let postId = UUID().uuidString

        var imageURL: String?
        if let image = draft.postImage {
            imageURL = await uploadImage(image, identifier: postId, folder: "posts")
        }

        let post = StudyPost(
            id: postId,
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
            floorPlanAssetName: draft.floorPlanAssetName,
            pinX: Double(draft.pinX),
            pinY: Double(draft.pinY),
            locationDescription: draft.locationDescription,
            photoAssetName: imageURL,
            subjects: draft.subjects,
            vibe: draft.vibe,
            capacity: draft.capacity,
            startTime: draft.startTime,
            endTime: draft.endTime,
            createdAt: Date(),
            statusOverride: nil
        )

        // Optimistic update: add post immediately, rollback on failure
        posts.insert(post, at: 0)
        savePost(post) { [weak self] in
            self?.posts.removeAll { $0.id == post.id }
        }
    }

    // MARK: - Users

    func saveUser(_ user: UserProfile) {
        userRepository.saveUser(user) { [weak self] errorMessage in
            Task { @MainActor in
                self?.setFailure(.firestore("Failed to save user: \(errorMessage)"))
            }
        }

        updatePostsForUser(user)
    }

    // Update all posts authored by this user with new profile info
    private func updatePostsForUser(_ user: UserProfile) {
        for i in posts.indices where posts[i].hostUserID == user.id {
            posts[i].hostUsername = user.username
            posts[i].hostYear = user.year
            posts[i].hostDegrees = user.degrees
            posts[i].hostMajor = user.major
            savePost(posts[i])
        }
    }

    func getUser(id: String) async -> UserProfile? {
        await userRepository.getUser(id: id)
    }

    // MARK: - Post Management

    func savePost(_ post: StudyPost, onFailure: (() -> Void)? = nil) {
        postRepository.savePost(post) { [weak self] errorMessage in
            Task { @MainActor in
                onFailure?()
                self?.setFailure(.firestore("Failed to save post: \(errorMessage)"))
            }
        }
    }

    func updatePost(_ post: StudyPost) {
        guard let idx = posts.firstIndex(where: { $0.id == post.id }) else { return }
        let previous = posts[idx]
        guard previous != post else { return }

        // Optimistic update: apply changes immediately, rollback on failure
        posts[idx] = post
        savePost(post) { [weak self] in
            guard let self else { return }
            if let rollbackIdx = self.posts.firstIndex(where: { $0.id == previous.id }) {
                self.posts[rollbackIdx] = previous
            }
        }
    }

    func deletePost(_ post: StudyPost) {
        guard posts.contains(where: { $0.id == post.id }) else { return }

        // Optimistic delete: remove immediately, restore on failure
        let previousPosts = posts
        posts.removeAll { $0.id == post.id }

        postRepository.deletePost(post.id) { [weak self] errorMessage in
            Task { @MainActor in
                self?.posts = previousPosts
                self?.setFailure(.firestore("Failed to delete post: \(errorMessage)"))
            }
        }
    }

    // MARK: - Location

    func start() {
        locationService.start()
    }
}
