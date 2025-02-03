//
//  SmartMentorProjectApp.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//

import SwiftUI

@main
struct SmartMentorProjectApp: App {
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    @State private var showMainApp = false
    
    var body: some Scene {
        WindowGroup {
            if isOnboarding {
                OnboardingContainerView()
            } else {
                ContentView()
            }
        }
    }
}

