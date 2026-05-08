import CoreLocation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import FirebaseCore
import Combine

final class AppState: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locManager = CLLocationManager()
    private let imageStorage = Storage.storage()
    private let database = Firestore.firestore()
    
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: UserProfile?
    @Published var posts: [StudyPost] = []
    @Published var selectedTab: Int = 0
    @Published var status: String = "Loading"
    @Published var currentLoc: CLLocation?
        
    func signUp(email: String, password: String, profile: UserProfile) async {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let uid = result.user.uid
            
            let userWithID = UserProfile(
                id: uid,
                email: email,
                firstName: profile.firstName,
                lastName: profile.lastName,
                username: profile.username,
                degrees: profile.degrees,
                year: profile.year,
                major: profile.major
            )
            
            saveUser(userWithID)
            
            await MainActor.run {
                currentUser = userWithID
                isAuthenticated = true
            }
            
            await loadPosts()
        } catch {
            await MainActor.run {
                status = "Sign up failed: \(error.localizedDescription)"
            }
        }
    }
    
    func login(email: String, password: String) async {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            let uid = result.user.uid
            
            if let user = await getUser(id: uid) {
                await MainActor.run {
                    currentUser = user
                    isAuthenticated = true
                }
                await loadPosts()
            }
        } catch {
            await MainActor.run {
                status = "Login failed: \(error.localizedDescription)"
            }
        }
    }
    
    func logout() {
        try? Auth.auth().signOut()
        currentUser = nil
        isAuthenticated = false
        selectedTab = 0
        posts = []
    }
    
    func checkSession() async {
        if let firebaseUser = Auth.auth().currentUser {
            if let user = await getUser(id: firebaseUser.uid) {
                await MainActor.run {
                    currentUser = user
                    isAuthenticated = true
                }
                await loadPosts()
            }
        }
    }
    
    func uploadImage(_ image: UIImage, identifier: String, folder:String) async -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else { return nil }
        
        let ref = Storage.storage().reference().child("\(folder)/\(identifier).jpg")
        
        do{
            let _ = try await ref.putDataAsync(imageData)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            return nil
        }
    }
    
    func saveUser(_ user: UserProfile) {
        database.collection("users").document(user.id).setData(user.convertFirestore()) { error in
            if let error {
                self.status = "Failed to save user: \(error.localizedDescription)"
            } else {
                self.status = "Saved user"
            }
        }
    }
    
    func getUser(id: String) async -> UserProfile? {
        let doc = try? await database.collection("users").document(id).getDocument()
        guard let data = doc?.data() else { return nil }
        return UserProfile.convertModel(id: id, data: data)
    }
        
    func loadPosts() async {
        do {
            let snapshot = try await database.collection("posts").getDocuments()
            let parsed = snapshot.documents.compactMap { doc in
                let post = StudyPost.convertModel(id: doc.documentID, data: doc.data())
                return post
            }
            await MainActor.run {
                posts = parsed
            }
        } catch {
            await MainActor.run {
                status = "Failed to load posts: \(error.localizedDescription)"
            }
        }
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
        savePost(post)
        selectedTab = 0
    }
    
    func savePost(_ post: StudyPost) {
        database.collection("posts").document(post.id).setData(post.convertFirestore()) { error in
            if let error {
                self.status = "Failed to save post: \(error.localizedDescription)"
            } else {
                self.status = "Saved post"
            }
        }
    }
    
    func updatePost(_ post: StudyPost) {
        guard let idx = posts.firstIndex(where: { $0.id == post.id }) else { return }
        posts[idx] = post
        savePost(post)
    }
    
    func deletePost(_ post: StudyPost) {
        posts.removeAll { $0.id == post.id }
        database.collection("posts").document(post.id).delete() { error in
            if let error {
                self.status = "Failed to delete post: \(error.localizedDescription)"
            }
        }
    }
    
    func detectBuilding(from: CLLocation) -> [BuildingOption]? {
        var buildingList: [BuildingOption] = []
        for building in MetadataStore.buildings{
            let center = CLLocation(latitude: building.lat, longitude: building.long)
            if center.distance(from: from) <= 60 {
                buildingList.append(building)
            }
        }
        return buildingList
    }
        
    func start() {
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLoc = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        status = "Location failed: \(error.localizedDescription)"
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied, .restricted:
            status = "Location permission denied"
        case .notDetermined:
            locManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
}
