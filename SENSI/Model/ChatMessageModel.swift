//
//  ChatMessageModel.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//

import Foundation

struct Milestone: Codable, Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var steps: [String]
    var completedSteps: [String] = []
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
    
    var options: [String]?

}


struct ChatResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model : String
    let choices : [Choice]
    let usage: Usage?
    let service_tier: String?
    let system_fingerprint: String?

}

struct Usage: Codable {
    let prompt_tokens: Int?
    let completion_tokens: Int?
    let total_tokens: Int?
}

struct Choice: Codable {
    let index: Int
    let message: Message
    let logprobs: String?
    let finish_reason: String?
}

struct Message : Codable {
    let role: String
    let content: String
//    let refusal: String?
}
