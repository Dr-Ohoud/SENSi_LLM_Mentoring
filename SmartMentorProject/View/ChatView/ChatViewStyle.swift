//
//  ChatViewStyle.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 02/03/2025.
//

import SwiftUI

struct ChatViewStyle: View {
    @State private var messages: [ChatMessage] = []
    @State private var inputText: String = ""
    @State private var isTyping: Bool = false
    @State private var responseText: String = ""
    @State private var isLoading: Bool = false
    @State private var planSaved: String? = "No"
    @State private var shouldNavigate: Bool = false
    @State private var chatOptionView: Bool = false
    @State private var showingAlert: Bool = false
    
    @State var registrationStep: Int = 7
    
    
    @EnvironmentObject var chatService: ChatServiceViewModel 
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        print(" The User: \(viewModel.currentUser?.fullName)")
        return (
            NavigationStack{
                
                VStack {
                    // MARK: - Top Bar
                    HStack {
                        Button(action: {
                            undoLastMessage()
                        }) {
                            Image(systemName: "arrow.uturn.backward")
                                .font(.title2)
                                .foregroundColor(registrationStep < 7 ? Color.gray : .accent)
//                                .foregroundColor(.accent)
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("No message to undo"), message: Text("Text your mentor to get started"), dismissButton: .default(Text("Got it!")))
                        }
                        .disabled(registrationStep < 7 )
                        .opacity(registrationStep < 7 ? 0.3 : 1.0)
                        Spacer()
                        
                        Text("Smart Mentor")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        if ((viewModel.currentUser) != nil) {
                            NavigationLink(destination:
                                            UserProfileView()
                                .navigationBarBackButtonHidden(false)) {
                                    Image(systemName: "person.fill")
                                        .font(.title2)
//                                        .foregroundColor(.accent)
                                        .foregroundColor(registrationStep < 7 ? Color.gray : .accent)
                                }
                                .accentColor(.accent)
                                .disabled(registrationStep < 7 )
                        } else {
                            NavigationLink(destination:
                                            LoginView()
                                .navigationBarBackButtonHidden(false)) {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .font(.title2)
                                        .foregroundColor(registrationStep < 7 ? Color.gray : .accent)
//                                        .foregroundColor(.accent)
                                }
                                .accentColor(.accent)
                                .disabled(registrationStep < 7 )
                            
                                .opacity(registrationStep < 7 ? 0.3 : 1.0)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    
                    // MARK: - Chat Messages
                    //                    VStack {
                    //                        //                        ScrollViewReader { proxy in
                    //                        //                            ScrollView {
                    //                        //                                ForEach(messages) { message in
                    //                        //                                    HStack {
                    //                        //                                        if message.isUser {
                    //                        //                                            Spacer()
                    //                        //                                            Text(message.text)
                    //                        //                                                .padding()
                    //                        //                                                .background(.accent)
                    //                        //                                                .foregroundColor(.white)
                    //                        //                                                .cornerRadius(10)
                    //                        //                                                .frame(maxWidth: 500, alignment: .trailing)
                    //                        //                                        } else {
                    //                        //                                            Text(message.text)
                    //                        //                                                .padding()
                    //                        //                                                .background(Color.gray.opacity(0.2))
                    //                        //                                                .cornerRadius(10)
                    //                        //                                                .frame(maxWidth: 500, alignment: .leading)
                    //                        //                                            Spacer()
                    //                        //                                        }
                    //                        //                                    }
                    //                        //                                    .padding()
                    //                        //                                    .id(message.id)
                    //                        //                                }
                    //                        //
                    //                        //                                if isTyping {
                    //                        //                                    HStack {
                    //                        //                                        Text("Mentor is typing...")
                    //                        //                                            .italic()
                    //                        //                                            .foregroundColor(.gray)
                    //                        //                                        Spacer()
                    //                        //                                    }
                    //                        //                                    .padding()
                    //                        //                                }
                    //                        //                            }
                    //                        //                            .onChange(of: messages.count) { _ in
                    //                        //                                if let lastMessage = messages.last {
                    //                        //                                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    //                        //                                }
                    //                        //                            }
                    //                        //                        }
                    //                        //
                    //                        //                        HStack {
                    //                        //                            HStack{
                    //                        //                                TextField("Type a message...", text: $inputText)
                    //                        //                                    .autocorrectionDisabled()
                    //                        //                                Spacer()
                    //                        //                                ProgressView()
                    //                        //                                    .opacity(isLoading ? 1 : 0)
                    //                        //
                    //                        //                            }
                    //                        //                            .padding()
                    //                        //                            .background(Color.gray.opacity(0.1))
                    //                        //                            .cornerRadius(10)
                    //                        //                            .padding(.horizontal, 10)
                    //                        //
                    //                        //
                    //                        //                            AsyncButton {
                    //                        //                                await sendMessage()
                    //                        //                            } label: {
                    //                        //                                Image(systemName: "paperplane.fill")
                    //                        //                                    .padding()
                    //                        //                                    .background(isLoading ? Color.gray : .accent)
                    //                        //                                    .foregroundStyle(.white)
                    //                        //                                    .cornerRadius(10)
                    //                        //                                    .padding(.horizontal, 10)
                    //                        //                            }
                    //                        //                        }
                    //                        //                        .padding()
                    //                        //                    }
                    //                        //                    .padding(.top, 10)
                    //
                    //
                    //                    }
                    
                    ScrollViewReader { proxy in
                        ScrollView {
                            ForEach(messages) { message in
                                ChatBubbleView(message: message)
                                    .id(message.id)
                            }
                            
                            if isTyping {
                                HStack {
                                    Text("Mentor is typing...")
                                        .italic()
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                .padding()
                            }
                        }
                        .onChange(of: messages.count) { _ in
                            if let lastMessage = messages.last {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                    
                    if registrationStep < 7 {
                        RegistrationView(
                            step: $registrationStep,
                            messages: $messages,
                            isLoading: $isLoading,
                            onComplete: completeRegistration
                        )
                    } else {
                        if self.chatOptionView{
                            ChatBubbleSelectionView(
                                message: "Would you like me to save this plan as a milestone to track progress and review later?",
                                options: ["Yes", "No, Thanks"],
                                selectedOption: $planSaved,
                                onSelect: { option in
                                    if option == "Yes" {
                                        if messages.count > 1 {
                                            extractSteps(response: messages.dropLast().last?.text ?? "")
                                            messages.append(ChatMessage(text: "Yes", isUser: true))
                                        } else {
                                            print("Not enough messages to extract steps.")
                                        }
                                        shouldNavigate = true
                                        self.chatOptionView = false
                                        
                                    } else if option == "No, Thanks" {
                                        messages.append(ChatMessage(text: "No, Thanks", isUser: true))
                                        self.chatOptionView = false
                                    }
                                }
                            )
                        } else {
                            ChatInputMessages(inputText: $inputText, isLoading: $isLoading, sendMessage: sendMessage)
                        }
                    }
                    NavigationLink(destination: MailstonesView()
                        .navigationBarBackButtonHidden(false),
                                   isActive: $shouldNavigate) {
                        EmptyView() // Keeps it hidden but allows navigation
                    }.tint(.accent)
                }
            }.tint(.accent)
        )
    }
}

extension ChatViewStyle {
    
    private func extractTitle(response: String) -> String {
        let sentences = response.components(separatedBy: ".") // Split into sentences
        
        for sentence in sentences {
            let trimmed = sentence.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if !trimmed.isEmpty, !trimmed.contains("Step"), !trimmed.contains("1."), !trimmed.contains("**") {
                return trimmed // Use the first meaningful sentence
            }
        }
        
        return "Untitled Milestone" // Default if no title is found
    }
    private func extractSteps(response: String) {
        let title = extractTitle(response: response)
        
        let lines = response.split(separator: "\n").map { String($0) }
        var extractedSteps: [String] = []
        
        for line in lines {
            if line.contains("**") {
                let step = line.replacingOccurrences(of: "**", with: "").trimmingCharacters(in: .whitespaces)
                extractedSteps.append(step)
            } else if line.hasPrefix("-") {
                let step = line.replacingOccurrences(of: "-", with: "").trimmingCharacters(in: .whitespaces)
                extractedSteps.append(step)
            }
        }
        
        if extractedSteps.isEmpty {
            print("❌ ERROR: No steps extracted. Cannot save.")
            return
        }
        
        let milestone = Milestone(title: title, steps: extractedSteps)
        print("✅ DEBUG: Extracted Milestone: \(milestone)")
        
        chatService.saveMailestoneToFirebase(milestone: milestone)
    }
//    private func extractSteps(response: String) {
//        let lines = response.split(separator: "\n").map { String($0) }
//        
//        var extractedSteps: [String] = []
//        var title: String = ""
//        
//        for line in lines {
//            if line.hasPrefix("### ") || line.hasPrefix("#### ") {
//                title = line.replacingOccurrences(of: "### ", with: "").replacingOccurrences(of: "####", with: "").trimmingCharacters(in: .whitespaces)
//            } else if line.contains("**") {
//                let step = line.replacingOccurrences(of: "**", with: "").trimmingCharacters(in: .whitespaces)
//                extractedSteps.append(step)
//            } else if line.hasPrefix("-") {
//                let step = line.replacingOccurrences(of: "-", with: "").trimmingCharacters(in: .whitespaces)
//                extractedSteps.append(step)
//            }
//        }
//        
//        if title.isEmpty {
//            print("❌ ERROR: Milestone title is empty. Cannot save.")
//            return
//        }
//        
//        if extractedSteps.isEmpty {
//            print("❌ ERROR: No steps extracted. Cannot save.")
//            return
//        }
//        
//        let milestone = Milestone(title: title, steps: extractedSteps)
//        print("✅ DEBUG: Extracted Milestone: \(milestone)")
//        chatService.saveMailestoneToFirebase(milestone: milestone)
//        
//    }
    
    private func undoLastMessage() {
        if messages.isEmpty {
            messages.removeLast()
            messages.removeLast()
        } else {
            self.showingAlert = true
        }
    }
    
    private func completeRegistration() {
        messages.append(ChatMessage(text: "Thank you, \(viewModel.currentUser?.fullName ?? "")! Your mentor is ready to assist you.", isUser: false))
        registrationStep = 7 // Enable normal chat mode
    }
    
    
    func sendMessage() async {
        guard !inputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let userMessage = ChatMessage(text: inputText, isUser: true)
        messages.append(userMessage)
        
        
        // Keep prompt, then clear the text field
        let prompt = inputText
        inputText = ""
        
        isTyping = true
        isLoading = true
        
        let mentorResponse = await chatService.getChatResponse(prompt: prompt, userViewModel: viewModel)
        
        isTyping = false
        isLoading = false
        
        // Append mentor’s response
        let mentorMessage = ChatMessage(text: mentorResponse, isUser: false)

        messages.append(mentorMessage)
        
        if mentorMessage.text.contains("1. **") ||  mentorMessage.text.contains("**Step ") ||  mentorMessage.text.contains("Step "){
            self.chatOptionView = true

            messages.append(ChatMessage(text: "Would you like me to save this plan as a milestone to track progress and review later?", isUser: false))
        }

    }
    
    
}

#Preview {
    
    ChatView()
}
