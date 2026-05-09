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
        ZStack{
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
    private let bgColor = Color(red: 0.91, green: 0.88, blue: 0.97)

    var body: some View {
        ZStack {
            bgColor.ignoresSafeArea()
            VStack(spacing: 20) {
                StudyBuddyLogo(size: 120)
                Text("StudyBuddy")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(Color.black)
            
            if appState.isLoading {
                LoadingOverlay()
            }
        }
    }
}

#Preview {
    ContentView()
}
