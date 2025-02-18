//
//  RequestBuilder.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//

import Foundation

class ChatGPTAPI {
    
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "OpenAI_API_Key") as? String
    
    func buildRequest (prompt: String, response: String, url: URL?) -> URLRequest? {
        
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
        
        let parameters: [String: Any] = [
            "model": "gpt-4o-mini",
            "temperature": 0,
            //            "messages": [
            //                [ "role": "user",
            //                  "content": prompt,
            //                ]
            "messages" : [
                [
                    "role" : "system",
                    "content":
                    """
                    You are friendly and approachable. You are a  mentor helping early-career individuals and recent graduates navigate thier careers:
                    
                    1. Maintain a supportive, empathetic, and reliable tone to build trust.
                    2. Provide personalized advice based on the user’s skills, interests, and ambitions.
                    3. Use cognitive techniques (assess passions, help with critical decisions, suggest career pathways).
                    4. Encourage reflection and continuous learning (ask follow-up questions, goal-setting).
                    5. IMPORTANT: Keep responses concise—limit your answer to about 4-5 sentences.
                    6. If user input seems incomplete or the conversation stalls, ask a clarifying question.
                    
                    Follow these rules before responding.
                    """
                ],
                [
                    "role": "user",
                    "content": prompt,
                ],
                [
                    "role": "assistant",
                    "content": response,
                ]
            ]
        ]
        
        // 2. Converting Parameters to JSON Data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else { return nil }
        request.httpBody = jsonData
        
        return request
        
    }
}

