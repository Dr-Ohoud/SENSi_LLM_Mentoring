//
//  SmartMentorProjectApp.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//

import SwiftUI
import Firebase

@main
struct SmartMentorProjectApp: App {
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    @State private var showMainApp = false
    @StateObject private var sessionUser = AuthViewModel()
    @StateObject private var chatService: ChatServiceViewModel = ChatServiceViewModel()
    @Environment(\.colorScheme) private var colorScheme
    
    init(){
        FirebaseApp.configure()
        NotificationManager.shared.requestAuthorization()
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundColor = UIColor.clear
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(named: "AccentColor") ?? .systemGreen]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "AccentColor") ?? .systemGreen]
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().tintColor = UIColor(named: "AccentColor") ?? .systemGreen
    }
    var body: some Scene {
        WindowGroup {
            if isOnboarding {
                OnboardingContainerView()
                    .environmentObject(sessionUser)
                    .environmentObject(chatService)
                    .preferredColorScheme(.light)
            } else {
                Main()
                    .environmentObject(sessionUser)
                    .environmentObject(chatService)
                    .preferredColorScheme(.light)
            }
        }
    }
}

