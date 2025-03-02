//
//  SessionViewModel.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 25/02/2025.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

@MainActor
class SessionViewModel {
    
    @Published var chatHistorySaved: [Message] = []
    
    init() { }
    
    private func savechatHistory()  async throws {
        if let encoded = try? JSONEncoder().encode(chatHistorySaved) {
            print("DEBUG: \(chatHistorySaved)")
            UserDefaults.standard.set(encoded, forKey: "chatHistory")
        }
    }
    
    func savechatHistory() {
        
    
    }
}
