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
    @Published var isLoading: Bool = false
    
    private var saveTask: DispatchWorkItem?
    
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
         You are mentor, a professional mentor specializing in career transitions and skill development. Your Experince is fully in \(String(describing: userViewModel.currentUser?.careerGoal)).
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
        -  **Experience Level:** \(String(describing: userViewModel.currentUser?.experienceLevel))
        -  **Bio:** \(String(describing: userViewModel.currentUser?.bio))
    
    
        ---
         **Example Conversation Structure:**
                
                **User:** *Mentor, I have a question about my career path. I’m considering shifting from Software Engineering to Data Analysis. What skills should I focus on?*
    
                **Mentor:** *That’s an excellent question. Shifting from Software Engineering to Data Analysis isn’t as drastic as it seems. First, tell me a bit about your technical background—do you have experience with Python, SQL, or any data visualization tools?*
    
                **User:** *I have a strong Python background and basic SQL knowledge, but I’ve never worked with tools like Tableau or Power BI.*
    
                **Mentor:** *That’s a great start! Python is a powerful tool for Data Analysis, and SQL is essential for handling databases. To strengthen your transition, I’d recommend focusing on:*  
                1 **Data Cleaning & Processing** – Learn how to use Pandas and NumPy efficiently.  
                2 **Visualization** – Get comfortable with Matplotlib, Seaborn, and Tableau/Power BI.  
                3 **SQL Mastery** – Since databases are fundamental, improving SQL skills will set you apart.  
    
                *(Pause for user response.)*
    
                **User:** *That sounds interesting. Do you think learning R would be beneficial, or is Python enough?*
    
                **Mentor:** *Python is more than enough! R is sometimes used in academic and statistical research, but Python dominates in business and industry applications. Since you already have a strong foundation in Python, focus on mastering its Data Science libraries like Pandas, Scikit-learn, and Seaborn.*  
    
                *(Pause for user response.)*
    
               
            **Follow these guidelines before responding.**
                **Keep responses structured like this. Allow brief pauses for user interaction.**
        ---
    
    If your response contains a sequence of instructions, \ 
    First prvide a title of steps provided then re-write those instructions in the following format:
    Title: 
    Description:
    
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
                print("Chat history loaded from Firebase for user: \(userID)")
            } else {
                print("[Error] Failed to load chat history: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func saveMilestoneToFirebase(milestone: Milestone) {
        print("Inside saveMilestoneToFirebase")
        
        guard let user = Auth.auth().currentUser else {
            print(" ERROR: User is nil, cannot proceed with Firestore update.")
            return
        }

        let userID = user.uid
        let userRef = Firestore.firestore().collection("users").document(userID)

        userRef.getDocument { (document, error) in
            if let error = error {
                print("ERROR: Failed to fetch user document: \(error.localizedDescription)")
                return
            }

            guard let document = document, document.exists, var user = try? document.data(as: User.self) else {
                print("ERROR: User document does not exist or failed to decode.")
                return
            }
            if user.milestones == nil {
                user.milestones = [milestone]
            } else {
                user.milestones?.append(milestone)
            }
            do {
                let encodedUser = try Firestore.Encoder().encode(user)
                userRef.setData(encodedUser, merge: true) { error in
                    if let error = error {
                        print("ERROR: Failed to save milestone: \(error.localizedDescription)")
                    } else {
                        print("SUCCESS: Milestone saved successfully for user: \(userID)")
                        self.loadMilestone() // Reload milestones after saving
                    }
                }
            } catch {
                print("ERROR: Encoding error: \(error.localizedDescription)")
            }
        }
    }
    
    func loadMilestone() {
        isLoading = true
        
        guard let user = Auth.auth().currentUser else {
            print("ERROR: No authenticated user found.")
            return
        }

        let userID = user.uid
        let userRef = Firestore.firestore().collection("users").document(userID)

        userRef.getDocument { (document, error) in
            if let error = error {
                print("ERROR: Failed to load milestones: \(error.localizedDescription)")
                return
            }

            guard let document = document, document.exists, let user = try? document.data(as: User.self) else {
                print("ERROR: User document does not exist or failed to decode.")
                return
            }

            DispatchQueue.main.async {
                self.milestones = user.milestones ?? []
//                print("Milestones loaded successfully: \(self.milestones)")
                self.isLoading = false
            }

        }
    }
    
    func updateMilestoneProgress(milestoneID: String, completedSteps: [String]) {
        guard let index = milestones.firstIndex(where: { $0.id == milestoneID }) else { return }
        milestones[index].completedSteps = completedSteps

        let updatedMilestone = milestones[index]

        guard let user = Auth.auth().currentUser else { return }
        let userID = user.uid
        let userRef = db.collection("users").document(userID)

        do {
            let encodedMilestone = try Firestore.Encoder().encode(updatedMilestone)

            userRef.updateData(["milestones": FieldValue.arrayUnion([encodedMilestone])]) { [weak self] error in
                if let error = error {
                    print("❌ ERROR: Failed to update milestone: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        self?.loadMilestone() // ✅ Ensure UI updates on the main thread
                    }
                }
            }
        } catch {
            print("❌ ERROR: Encoding failed: \(error.localizedDescription)")
        }
    }
    
    private func saveUpdatedMilestone(_ milestone: Milestone) {
            guard let user = Auth.auth().currentUser else { return }
            let userID = user.uid
            let userRef = db.collection("users").document(userID)

            do {
                let encodedMilestone = try Firestore.Encoder().encode(milestone)
                userRef.updateData(["milestones": FieldValue.arrayUnion([encodedMilestone])]) { error in
                    if let error = error {
                        print("ERROR: Failed to update milestone: \(error.localizedDescription)")
                    } else {
                        print("SUCCESS: Milestone progress updated.")
                    }
                }
            } catch {
                print("ERROR: Encoding failed: \(error.localizedDescription)")
            }
        }
    
    @MainActor
    func updateMilestoneCompletion(for milestone: Milestone) async -> Bool {
        guard let user = Auth.auth().currentUser else { return false }

        let userRef = Firestore.firestore().collection("users").document(user.uid)

        do {
            let snapshot = try await userRef.getDocument()
            var user = try snapshot.data(as: User.self)

            if let index = user.milestones?.firstIndex(where: { $0.id == milestone.id }) {
                user.milestones?[index].completedSteps = milestone.completedSteps

                try userRef.setData(from: user, merge: true)

                // Optional: refresh milestones in view
                loadMilestone()
                return true
            }

        } catch {
            print("❌ Failed to update milestone completion: \(error.localizedDescription)")
        }

        return false
    }

    func deleteMilestone(withId id: String) async {
        guard let user = Auth.auth().currentUser else { return }

        let userRef = Firestore.firestore().collection("users").document(user.uid)

        do {
            let snapshot = try await userRef.getDocument()
            var user = try snapshot.data(as: User.self)

            user.milestones?.removeAll { $0.id == id }

            try userRef.setData(from: user, merge: true)
            loadMilestone()

            print("✅ Milestone deleted.")
        } catch {
            print("❌ Failed to delete milestone: \(error.localizedDescription)")
        }
    }
    
    func updateMilestoneTitle(id: String, newTitle: String) async {
        guard let user = Auth.auth().currentUser else { return }

        let userRef = Firestore.firestore().collection("users").document(user.uid)

        do {
            var user = try await userRef.getDocument().data(as: User.self)

            if let index = user.milestones?.firstIndex(where: { $0.id == id }) {
                user.milestones?[index].title = newTitle
                try userRef.setData(from: user, merge: true)
                loadMilestone()
            }
        } catch {
            print("❌ Failed to update milestone title: \(error.localizedDescription)")
        }
    }
    
    func scheduleWeeklyReminderIfNeeded() {
        
        let hasIncompleteMilestone = milestones.contains { milestone in
            milestone.completedSteps.count < milestone.steps.count
        }

        guard hasIncompleteMilestone else {
            print("All milestones completed — no reminder scheduled.")
            return
        }

        // 2. Prepare notification content
        let content = UNMutableNotificationContent()
        content.title = "🚀 Keep Going!"
        content.body = "You have milestones waiting. Come back and complete your steps!"
        content.sound = .default
        content.badge = 1

        // 3. Set trigger: Every Sunday at 9:00 AM
        var dateComponents = DateComponents()
        dateComponents.weekday = 1 // Sunday
        dateComponents.hour = 9
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        // 4. Schedule request
        let request = UNNotificationRequest(
            identifier: "weeklyMilestoneReminder",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule reminder: \(error.localizedDescription)")
            } else {
                print("Weekly milestone reminder scheduled.")
            }
        }
    }
}
