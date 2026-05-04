//
//  ContentView.swift
//  StudyBuddy
//
//  Created by Ina Song on 3/5/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState()

    var body: some View {
        Group {
            if appState.isAuthenticated {
                MainTabView()
                    .environmentObject(appState)
            } else {
                AuthFlowView()
                    .environmentObject(appState)
            }
        }
    }
}

#Preview {
    ContentView()
}
