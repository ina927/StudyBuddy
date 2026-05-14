# StudyBuddy

**StudyBuddy** is an iOS app for UTS students to discover, share, and join study sessions on campus in real time.
Students can post where they are studying, what they are studying, and exactly where to find them using floor-plan pinning and location photos.

---

## What StudyBuddy Does

- Create study posts with:
  - subject(s)
  - vibe / study style
  - capacity
  - start/end time
- Detect nearby campus context using device location (with user permission).
- Let hosts pin their exact position on a floor plan.
- Support photo uploads for easier wayfinding.
- Browse active posts in a feed and open details for each session.
- Maintain user profile data (name, degree(s), year, major, photo).

---

### Getting Started
Download the files or clone the repo, drag the given **GoogleService-Info.plist file** (attached to the canvas submission) to the root folder before building. Make sure to run on a device for accurate building detection.

### Github Repo
https://github.com/ina927/StudyBuddy

### Demo Video
https://youtu.be/aBZPM54VQe4?si=RrZNhj1wuree4xCC

### Figma
https://www.figma.com/design/FPP1hrn9tWTugRvbyZmh7G/StudyBuddy?node-id=0-1&t=4MrD6nXgzOLwCekl-1

---

## 🧱 Architecture Overview

The project follows a layered structure with clear separation between UI, app state orchestration, models, and services:

- **Views (`StudyBuddy/Views`)**
  - SwiftUI screens and reusable components.
- **App state (`StudyBuddy/App`)**
  - `AppState` coordinates auth/session, posts, user data, UI status, and service orchestration.
  - `UIState` + `UserFacingError` provide typed UI status and error presentation.
- **Models (`StudyBuddy/Models`)**
  - `StudyPost`, `UserProfile`, `CreatePostDraft`.
- **Services (`StudyBuddy/Services`)**
  - Firebase repositories (`PostRepository`, `UserRepository`)
  - Auth wrapper (`AuthService`)
  - Media upload (`ImageStorageService`)
  - Location abstraction (`LocationService`)
  - Static metadata (`MetadataStore`)
  - Firestore path constants (`FirestorePath`)

---

## 🗂️ Directory Structure

```text
StudyBuddy/
├─ App/
│  ├─ AppState.swift
│  └─ UIState.swift
├─ Models/
│  ├─ CreatePostDraft.swift
│  ├─ StudyPost.swift
│  └─ UserProfile.swift
├─ Services/
│  ├─ AuthService.swift
│  ├─ FirestorePath.swift
│  ├─ ImageStorageService.swift
│  ├─ LocationService.swift
│  ├─ MetadataStore.swift
│  ├─ PostRepository.swift
│  └─ UserRepository.swift
├─ Views/
│  ├─ Auth/
│  ├─ Common/
│  ├─ CreatePost/
│  └─ Feed/
├─ Assets.xcassets/
├─ ContentView.swift
├─ StudyBuddyApp.swift
└─ ...
