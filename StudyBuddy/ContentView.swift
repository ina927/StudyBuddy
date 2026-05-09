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
        ZStack{
            Group {
                if appState.isAuthenticated {
                    MainTabView()
                } else {
                    AuthFlowView()
                }
            }
            
            if appState.isLoading {
                LoadingOverlay()
            }
        }
    }
}

#Preview {
    ContentView()
}
