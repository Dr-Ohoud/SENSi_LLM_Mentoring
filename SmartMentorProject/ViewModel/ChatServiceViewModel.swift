//
//  ChatServiceViewModel.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//


import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class ChatServiceViewModel: ObservableObject{
    private let networkManager = NetworkManager()
    private let requestBuilder = ChatGPTAPI()
    private let errorMessage = "Error: Unable to generate response"
    private let url = URL(string: "https://api.openai.com/v1/chat/completions")
    
    private var db = Firestore.firestore()  // Firestore database reference
    
    @Published var chatHistory: [Message] = []
    @Published var milestones: [Milestone] = []
    
    private var saveTask: DispatchWorkItem?
    
    init() {
        loadChatHistory()
//        loadMailestone()
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
             1 **Engage naturally** – Respond like a real mentor, keeping an interactive and friendly tone.
             2 **Ask clarifying questions** before giving direct advice.
             3 **Use dialogue format**: Address the user by name when possible and structure responses in a conversational manner.
             4 **Break down explanations** step by step while keeping them concise.
             5 **Make recommendations dynamically** – If relevant, mention useful courses, tools, or strategies.
             6 **Encourage reflection** – Instead of just giving answers, prompt the user to think critically about their choices.
             7 **Encourage conversation** – Instead of just giving all the steps, send each step speratly to help user think in each step independently.
    
      **Guidelines for providing mentorship:**
            1 Maintain a supportive, empathetic, and reliable tone to build trust.
            2 Provide **personalized** advice based on the user’s **skills, interests, and ambitions**.
            3 Use **cognitive techniques** (assess passions, help with decision-making, suggest career pathways).
            4 Encourage **reflection and continuous learning** (ask follow-up questions, guide goal-setting).
            5 If user input seems incomplete or unclear, **ask a clarifying question** before responding.
            6 When responding, break down complex ideas into **step-by-step guidance** using **Chain-of-Thought reasoning**.
            7 Provide **actionable insights**—suggesting specific skills to learn, roles to explore, or projects to build.
            8 Keep responses **concise yet informative** (4-5 sentences max).
    
    
        ---
        **User Profile for Context-Aware Responses:**
        -  **Name:** \(String(describing: userViewModel.currentUser?.fullName))
        -  **Career Goal:** \(String(describing: userViewModel.currentUser?.careerGoal))
        -  **Education Level:** \(String(describing: userViewModel.currentUser?.eduactionLevel))
      
        -  **Bio:** \(String(describing: userViewModel.currentUser?.bio))
    
    
        ---
         **Example Conversation Structure:**
                
                **User:** *Dr. Latifa, I have a question about my career path. I’m considering shifting from Software Engineering to Data Analysis. What skills should I focus on?*
    
                **Latifa:** *That’s an excellent question. Shifting from Software Engineering to Data Analysis isn’t as drastic as it seems. First, tell me a bit about your technical background—do you have experience with Python, SQL, or any data visualization tools?*
    
                **User:** *I have a strong Python background and basic SQL knowledge, but I’ve never worked with tools like Tableau or Power BI.*
    
                **Latifa:** *That’s a great start! Python is a powerful tool for Data Analysis, and SQL is essential for handling databases. To strengthen your transition, I’d recommend focusing on:*  
                1 **Data Cleaning & Processing** – Learn how to use Pandas and NumPy efficiently.  
                2 **Visualization** – Get comfortable with Matplotlib, Seaborn, and Tableau/Power BI.  
                3 **SQL Mastery** – Since databases are fundamental, improving SQL skills will set you apart.  
    
                *(Pause for user response.)*
    
                **User:** *That sounds interesting. Do you think learning R would be beneficial, or is Python enough?*
    
                **Latifa:** *Python is more than enough! R is sometimes used in academic and statistical research, but Python dominates in business and industry applications. Since you already have a strong foundation in Python, focus on mastering its Data Science libraries like Pandas, Scikit-learn, and Seaborn.*  
    
                *(Pause for user response.)*
    
                ---
            **Follow these guidelines before responding.**
                **Keep responses structured like this. Allow brief pauses for user interaction.**
    
    If your response contains a sequence of instructions, \ 
    re-write those instructions in the following format:

    Step 1 - ...
    Step 2 - …
    …
    Step N - …

    """),
            Message(role: "user", content: " \(prompt)")
        ]
        
        messages.append(contentsOf: chatHistory)
        
        guard let request = requestBuilder.buildRequest(messages: messages, url: url) else {
            print("[Error] Failed to build request")
            return errorMessage
        }
        
        do {
            let data = try await networkManager.sendRequest(request)
            
            let responseText = decodeResponse(data)
            let assistantMessage = Message(role: "assistant", content: responseText)
            
            chatHistory.append(assistantMessage)
            saveChatHistoryToFirebase()
            print(data)
            return responseText
            
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
    
    private func saveChatHistoryToFirebase() {
        saveTask?.cancel()

            let task = DispatchWorkItem { [weak self] in
                guard let self = self, let user = Auth.auth().currentUser else { return }
                let userID = user.uid
                let userRef = db.collection("users").document(userID) // Target the user's document

                // Convert chat history to an array of dictionaries
                let messagesDict = chatHistory.map { ["role": $0.role, "content": $0.content] }

                // Update the user document with the chat history
                userRef.updateData([
                    "chatHistory": FieldValue.arrayUnion(messagesDict),
                    "lastUpdated": Timestamp(date: Date())
                ]) { error in
                    if let error = error {
                        print("[Error] Failed to save chat history: \(error.localizedDescription)")
                    } else {
                        print("Chat history updated successfully for user: \(userID)")
                    }
                }
            }

            self.saveTask = task
            DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: task) // Save
     }
    
    private func loadChatHistory() {
        guard let user = Auth.auth().currentUser else { return }
        let userID = user.uid
        let userRef = db.collection("users").document(userID)

        userRef.getDocument { (document, error) in
            if let document = document, document.exists, let data = document.data(),
               let messagesData = data["chatHistory"] as? [[String: String]] {

                self.chatHistory = messagesData.compactMap { dict in
                    guard let role = dict["role"], let content = dict["content"] else { return nil }
                    return Message(role: role, content: content)
                }
//                print(self.chatHistory)
                print("Chat history loaded from Firebase for user: \(userID)")
            } else {
                print("[Error] Failed to load chat history: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func saveMailestoneToFirebase(milestone: Milestone) {
        print("Inside saveMailestoneToFirebase")
        saveTask?.cancel() // Cancel previous save if a new message comes in
        
        let task = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            
            if let user = Auth.auth().currentUser {
                print("DEBUG: User is still signed in before saving milestone: \(user.uid)")
            } else {
                print("DEBUG: User is already nil before saving milestone!")
            }
            
            guard let user = Auth.auth().currentUser else {
                print("ERROR: User is nil, cannot proceed with Firestore update.")
                return
            }
            let userID = user.uid
            let userRef = db.collection("users").document(userID)
            
            let milestoneData: [String: Any] = [
                "title": milestone.title,
                "steps": milestone.steps
            ]
            userRef.updateData(["milestones": FieldValue.arrayUnion([milestoneData])]) { error in
                if let error = error {
                    print("[Error] Failed to save milestone: \(error.localizedDescription)")
                    
                    if let user = Auth.auth().currentUser {
                        print("DEBUG: User still signed in after error: \(user.uid)")
                    } else {
                        print("DEBUG: User became NIL after Firestore error!")
                    }
                } else {
                    print("Milestone updated successfully for user: \(userID)")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        print("🔄 DEBUG: Calling loadMilestone() after save.")
                        self.loadMilestone()
                    }
                }
            }
        }
        self.saveTask = task
        print("🔵 DEBUG: Executing save task.")
        DispatchQueue.main.async(execute: task)
//         DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: task) // Save
//        DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: task) {
//            if let updatedUser = Auth.auth().currentUser {
//                print("User still logged in: \(updatedUser.uid)")
//                self.loadMilestone()
//            } else {
//                print("User became nil after Firestore update.")
//            }
//        }
        //DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: task) // Save
    }
    func loadMilestone() {
        guard let user = Auth.auth().currentUser else { return }
        let userID = user.uid
        let userRef = db.collection("users").document(userID)

        userRef.getDocument { (document, error) in
            if let document = document, document.exists, let data = document.data(),
               let milestonesData = data["milestones"] as? [[String: Any]] {
                self.milestones = milestonesData.compactMap { dict in
                    guard let milestoneTitle = dict["title"] as? String,
                          let milestoneSteps = dict["steps"] as? [String] else { return nil }
                    
                    return Milestone(title: milestoneTitle, steps: milestoneSteps)
                }
                
                print(self.milestones)
                print("✅ Milestones loaded from Firebase for user: \(userID)")
            } else {
                print("[Error] Failed to load milestones: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
//    func loadMailestone() {
//        guard let user = Auth.auth().currentUser else { return }
//        let userID = user.uid
//        let userRef = db.collection("users").document(userID)
//        
//        userRef.getDocument { (document, error) in
//            if let document = document, document.exists, let data = document.data(),
//               let milestonesData = data["milestones"] as? [[String: Any]] {
//                
//                self.Milestone = milestonesData.compactMap { dict in
//                    guard let milestoneTitle = dict["title"] as? String,
//                          let milestoneSteps = dict["steps"] as? [String] else { return nil }
//                    
//                    return Milestone(title: milestoneTitle, steps: milestoneSteps)
//                }
//                
//                print(self.milestones)
//                print("Milestones loaded from Firebase for user: \(userID)")
//            } else {
//                print("[Error] Failed to load milestones: \(error?.localizedDescription ?? "Unknown error")")
//            }
//        }
////        userRef.getDocument { (document, error) in
////            if let document = document, document.exists, let data = document.data(),
////               let milestonesData = data["mailestone"] as? [[String: Any]] {
////
////                self.mailstones = milestonesData.compactMap { dict in
////                    guard let milestoneTitle = dict["title"] as? String,
////                          let milestoneSteps = dict["steps"] as? [String] else { return nil }
////                    
////                    // Create and return a Milestone object
////                    return Milestone(title: milestoneTitle, steps: milestoneSteps)
////                }
////                
////                print(self.mailstones)
////                print("Milestones loaded from Firebase for user: \(userID)")
////            } else {
////                print("[Error] Failed to load milestones: \(error?.localizedDescription ?? "Unknown error")")
////            }
////        }
//    }
    

}
