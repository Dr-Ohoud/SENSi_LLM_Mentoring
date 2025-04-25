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

