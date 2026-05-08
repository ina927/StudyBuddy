//
//  ContentView.swift
//  StudyBuddy
//
//  Created by Ina Song on 3/5/2026.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            if appState.isAuthenticated {
                MainTabView()
            } else {
                AuthFlowView()
            }
        }
    }
}

#Preview {
    ContentView()
}
