//
//  ContentView.swift
//  StudyBuddy
//
//  Created by Ina Song on 3/5/2026.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var showSplash = true

    var body: some View {
        if showSplash {
            SplashView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            showSplash = false
                        }
                    }
                }
        } else {
            Group {
                if appState.isAuthenticated {
                    MainTabView()
                } else {
                    AuthFlowView()
                }
            }
            .transition(.opacity)
        }
    }
}

struct SplashView: View {
    var body: some View {
        ZStack {
            Color(red: 0.882, green: 0.867, blue: 0.961).ignoresSafeArea()
            VStack(spacing: 20) {
                StudyBuddyLogo(size: 120)
                Text("StudyBuddy")
                    .font(.system(size: 36, weight: .bold))
            }
        }
    }
}

#Preview {
    ContentView()
}
