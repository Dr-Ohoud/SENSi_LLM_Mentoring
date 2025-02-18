//
//  ChatServiceViewModel.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//


import Foundation

class ChatServiceViewModel {
    private let networkManager = NetworkManager()
    private let requestBuilder = ChatGPTAPI()
    private let errorMessage = "Error: Unable to generate response"
    private let url = URL(string: "https://api.openai.com/v1/chat/completions")
    
    // 4. Executing the Request with URLSession
    func getChatResponse(prompt: String, userViewModel: AuthViewModel) async -> String {
        
        let assistantPrompt = """
        User fullName: \(String(describing: await userViewModel.currentUser?.fullName))
        Skills: \(String(describing: await userViewModel.currentUser?.skills))
        Interests: \(String(describing: await userViewModel.currentUser?.interests))
        Bio: \(String(describing: await userViewModel.currentUser?.bio))
        Eduaction Level: \(String(describing: await userViewModel.currentUser?.eduactionLevel)) 
        Career Goal: \(String(describing: await userViewModel.currentUser?.careerGoal)) 
        Skill Gap: \(String(describing: await userViewModel.currentUser?.skillGap)) 
        """
        
        let instructionalPrompt = """
        You are SmartMentor, a virtual AI mentor helping early-career individuals and recent graduates navigate careers in AI and related fields.
        
        1. Maintain a supportive, empathetic, and reliable tone to build trust.
        2. Provide personalized advice based on the user’s skills, interests, and ambitions.
        3. Use cognitive techniques (assess passions, help with critical decisions, suggest career pathways).
        4. Encourage reflection and continuous learning (ask follow-up questions, goal-setting).
        5. IMPORTANT: Keep responses concise—limit your answer to about 4-5 sentences.
        6. If user input seems incomplete or the conversation stalls, ask a clarifying question.
        
        Follow these rules before responding.
        """
        
        let finalPrompt = """
        \(instructionalPrompt)
        
        \(assistantPrompt)
        
        User Query:
        \(prompt)
        """
        
        guard let request = requestBuilder.buildRequest(prompt: finalPrompt, response: <#String#>, url: url) else {
            print("[Error] Failed to build request")
            return errorMessage
        }
        
        do {
            let data = try await networkManager.sendRequest(request)
            
            // Debug: Print raw JSON
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response:\n\(jsonString)")
            }
            
            print(data)
            return decodeResponse(data)
            
        } catch {
            print("[Error] Failed to send request: \(error.localizedDescription)")
            return errorMessage
        }
    }
    
    // Converting JSON Response to Structs
    private func decodeResponse(_ data: Data) -> String {
        do {
            let response = try JSONDecoder().decode(ChatResponse.self, from: data)
            return response.choices.first?.message.content ?? "No Response Found"
            
        } catch {

            print ("[Error] Failed to decode response: \(error.localizedDescription)")
            return errorMessage
        }
    }
    
    
    
    
}
