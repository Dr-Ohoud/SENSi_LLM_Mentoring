//
//  ChatServiceViewModel.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//


import Foundation

@MainActor
class ChatServiceViewModel {
    private let networkManager = NetworkManager()
    private let requestBuilder = ChatGPTAPI()
    private let errorMessage = "Error: Unable to generate response"
    private let url = URL(string: "https://api.openai.com/v1/chat/completions")
    
    @Published var chatHistory: [Message] = []
    
    init() {
        loadChatHistory()
    }
    
    // 4. Executing the Request with URLSession
    func getChatResponse(prompt: String, userViewModel: AuthViewModel) async -> String {
        
        let userMessage = Message(role: "user", content: prompt)
        chatHistory.append(userMessage)
        
        var messages = [
            
            Message(role: "system", content:
                        """
         You are mentor, a professional mentor specializing in career transitions and skill development. 
             You guide early-career professionals and graduates in their career paths using a natural and conversational approach.
             
             **Guidelines for your responses:**
             1️⃣ **Engage naturally** – Respond like a real mentor, keeping an interactive and friendly tone.
             2️⃣ **Ask clarifying questions** before giving direct advice.
             3️⃣ **Use dialogue format**: Address the user by name when possible and structure responses in a conversational manner.
             4️⃣ **Break down explanations** step by step while keeping them concise.
             5️⃣ **Make recommendations dynamically** – If relevant, mention useful courses, tools, or strategies.
             6️⃣ **Encourage reflection** – Instead of just giving answers, prompt the user to think critically about their choices.
             7️⃣ **Encourage conversation** – Instead of just giving all the steps, send each step speratly to help user think in each step independently. 

        ---
        **User Profile for Context-Aware Responses:**
        - 👤 **Name:** \(String(describing: userViewModel.currentUser?.fullName))
        - 🎯 **Career Goal:** \(String(describing: userViewModel.currentUser?.careerGoal))
        - 📚 **Education Level:** \(String(describing: userViewModel.currentUser?.eduactionLevel))
        - 🛠 **Skills:** \(String(describing: userViewModel.currentUser?.skills))
        - 💡 **Interests:** \(String(describing: userViewModel.currentUser?.interests))
        - 📖 **Bio:** \(String(describing: userViewModel.currentUser?.bio))
        - ⚡ **Skill Gap:** \(String(describing: userViewModel.currentUser?.skillGap))
    
        ---
         **Example Conversation Structure:**
                
                **User:** *Dr. Latifa, I have a question about my career path. I’m considering shifting from Software Engineering to Data Analysis. What skills should I focus on?*

                **Latifa:** *That’s an excellent question. Shifting from Software Engineering to Data Analysis isn’t as drastic as it seems. First, tell me a bit about your technical background—do you have experience with Python, SQL, or any data visualization tools?*

                **User:** *I have a strong Python background and basic SQL knowledge, but I’ve never worked with tools like Tableau or Power BI.*

                **Latifa:** *That’s a great start! Python is a powerful tool for Data Analysis, and SQL is essential for handling databases. To strengthen your transition, I’d recommend focusing on:*  
                1️⃣ **Data Cleaning & Processing** – Learn how to use Pandas and NumPy efficiently.  
                2️⃣ **Visualization** – Get comfortable with Matplotlib, Seaborn, and Tableau/Power BI.  
                3️⃣ **SQL Mastery** – Since databases are fundamental, improving SQL skills will set you apart.  

                *(Pause for user response.)*

                **User:** *That sounds interesting. Do you think learning R would be beneficial, or is Python enough?*

                **Latifa:** *Python is more than enough! R is sometimes used in academic and statistical research, but Python dominates in business and industry applications. Since you already have a strong foundation in Python, focus on mastering its Data Science libraries like Pandas, Scikit-learn, and Seaborn.*  

                *(Pause for user response.)*

                ---
                **Keep responses structured like this. Allow brief pauses for user interaction.**
    """),
            //"""
            //                You are friendly and approachable mentor helping early-career individuals and recent graduates navigate thier careers:
            //
            //                1. Maintain a supportive, empathetic, and reliable tone to build trust.
            //                2. Provide personalized advice based on the user’s skills, interests, and ambitions.
            //                3. Use cognitive techniques (assess passions, help with critical decisions, suggest career pathways).
            //                4. Encourage reflection and continuous learning (ask follow-up questions, goal-setting).
            //                5. IMPORTANT: I want you to respond naturally, and if they ask for information, provide it concisely.
            //                6. If user input seems incomplete or the conversation stalls, ask a clarifying question.
            //
            //                Follow these rules before responding.
            //
            //                This the user information to take it in your considration:
            //
            //                User fullName: \(String(describing: userViewModel.currentUser?.fullName))
            //                Skills: \(String(describing: userViewModel.currentUser?.skills))
            //                Interests: \(String(describing: userViewModel.currentUser?.interests))
            //                Bio: \(String(describing: userViewModel.currentUser?.bio))
            //                Eduaction Level: \(String(describing: userViewModel.currentUser?.eduactionLevel))
            //                Career Goal: \(String(describing: userViewModel.currentUser?.careerGoal))
            //                Skill Gap: \(String(describing: userViewModel.currentUser?.skillGap))
            //            """
            
            Message(role: "user", content: " \(prompt)")
        ]
        
        messages.append(contentsOf: chatHistory)
        
        guard let request = requestBuilder.buildRequest(messages: messages, url: url) else {
            print("[Error] Failed to build request")
            return errorMessage
        }
        
        //        do {
        //            let data = try await networkManager.sendRequest(request)
        //
        //            if let jsonString = String(data: data, encoding: .utf8) {
        //                print("Raw JSON response:\n\(jsonString)")
        //            }
        //
        //            let responseText = decodeResponse(data)
        //            let assistantMessage = Message(role: "assistant", content: responseText)
        //
        //            print("Response from assistant:\(responseText)")
        //            print("Assistant message:\(assistantMessage)")
        //            chatHistory.append(assistantMessage)
        //            saveChatHistory()
        //        } catch {
        //            print("[Error] Failed to send request: \(error.localizedDescription)")
        //            return errorMessage
        //        }
        
        //        let instructionalPrompt = """
        //        You are SmartMentor, a virtual AI mentor helping early-career individuals and recent graduates navigate careers in AI and related fields.
        //
        //        1. Maintain a supportive, empathetic, and reliable tone to build trust.
        //        2. Provide personalized advice based on the user’s skills, interests, and ambitions.
        //        3. Use cognitive techniques (assess passions, help with critical decisions, suggest career pathways).
        //        4. Encourage reflection and continuous learning (ask follow-up questions, goal-setting).
        //        5. IMPORTANT: Keep responses concise—limit your answer to about 4-5 sentences.
        //        6. If user input seems incomplete or the conversation stalls, ask a clarifying question.
        //
        //        Follow these rules before responding.
        //        """
        //
        //        let finalPrompt = """
        //        \(instructionalPrompt)
        //
        //        \(assistantPrompt)
        //
        //        User Query:
        //        \(prompt)
        //        """
        
        
        do {
            let data = try await networkManager.sendRequest(request)
            
            // Debug: Print raw JSON
            if let jsonString = String(data: data, encoding: .utf8) {
                //                print("Raw JSON response:\n\(jsonString)")
            }
            
            let responseText = decodeResponse(data)
            let assistantMessage = Message(role: "assistant", content: responseText)
            
            print("Response from assistant:\(responseText)")
            chatHistory.append(assistantMessage)
            saveChatHistory()
            print(data)
            return responseText
            //            return decodeResponse(data)
            
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
    
    private func loadChatHistory() {
        if let savedData = UserDefaults.standard.data(forKey: "chatHistory"),
           let decoded = try? JSONDecoder().decode([Message].self, from: savedData) {
            chatHistory = decoded
            
            print(chatHistory)
        }
    }
    
    private func saveChatHistory() {
        if let encoded = try? JSONEncoder().encode(chatHistory) {
            print("chat saved!")
            UserDefaults.standard.set(encoded, forKey: "chatHistory")
        }
    }
    
}
