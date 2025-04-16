//
//  RequestBuilder.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//

import Foundation
import StoreKit

class ChatGPTAPI {
    
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "OpenAI_API_Key") as? String
    
    func buildRequest (messages: [Message], url: URL?) -> URLRequest? {
        
        // 1. Constructing the URLRequest Object
        guard let apiURL = url else { return nil }
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        if let apiKey = apiKey {
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        } else {
            // Handle missing API key
            print("DEBUG: Missing API Key")
            return nil
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 2. Convert `messages` to JSON format
        let formattedMessages: [[String: String]] = messages.map {
            ["role": $0.role, "content": $0.content]
        }
        
        let parameters: [String: Any] = [
            "model": "gpt-4o-mini",
            "temperature": 0.8,
            "messages": formattedMessages,
//                [
//                [ "role": "user",
//                  "content": prompt,
//                ]
//            ]
        ]
        
        // 3. Convert Parameters to JSON Data
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = jsonData
        } catch {
            print("Failed to encode JSON: \(error.localizedDescription)")
            return nil
        }

        return request
        
    }
}

