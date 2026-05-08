//
//  StudyBuddyApp.swift
//  StudyBuddy
//
//  Created by Ina Song on 3/5/2026.
//

import SwiftUI
import FirebaseCore

@main
struct StudyBuddyApp: App {
    @StateObject private var appState = AppState()

    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .task {
                    await appState.checkSession()
                    appState.start()
                }
        }
    }
}
