//
//  Chat.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 24/02/2025.
//

import SwiftUI

//struct ChatViewStle: View {
//    @State private var messages: [ChatMessage] = []
//    @State private var inputText: String = ""
//    @State private var isTyping: Bool = false
//    @State private var isLoading: Bool = false
//    @State private var registrationStep: Int = 1 // Track registration step
//
//    // User Registration Data
//    @State private var userData = UserData()
//
//    let chatService: ChatServiceViewModel = ChatServiceViewModel()
//    @EnvironmentObject var viewModel: AuthViewModel
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                // Top Bar
//                ChatHeaderView()
//
//                // Chat Messages
//                ScrollViewReader { proxy in
//                    ScrollView {
//                        ForEach(messages) { message in
//                            ChatBubbleView(message: message)
//                                .id(message.id)
//                        }
//
//                        if isTyping {
//                            TypingIndicatorView()
//                        }
//                    }
//                    .onChange(of: messages.count) { _ in
//                        if let lastMessage = messages.last {
//                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
//                        }
//                    }
//                }
//
//                // Conditional View: Registration or Chat Input
//                if registrationStep <= 4 {
//                    RegistrationFlowView(
//                        step: $registrationStep,
////                        userData: $userData,
//                        messages: $messages,
//                        onComplete: completeRegistration
//                    )
//                } else {
//                    ChatInputView(inputText: $inputText, isLoading: $isLoading, sendMessage: sendMessage)
//                }
//            }
//        }
//    }
//    
//    // Complete Registration
//    private func completeRegistration() {
//        messages.append(ChatMessage(text: "Thank you, \(userData.fullName)! Your mentor is ready to assist you.", isUser: false))
//        registrationStep = 5 // Enable normal chat mode
//    }
//    
//    // Send Chat Message
//    private func sendMessage() async {
//        guard !inputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
//        
//        let userMessage = ChatMessage(text: inputText, isUser: true)
//        messages.append(userMessage)
//        inputText = ""
//
//        isTyping = true
//        isLoading = true
//        
//        let mentorResponse = await chatService.getChatResponse(prompt: userMessage.text, userViewModel: viewModel)
//        
//        isTyping = false
//        isLoading = false
//        
//        let mentorMessage = ChatMessage(text: mentorResponse, isUser: false)
//        messages.append(mentorMessage)
//    }
//}

#Preview {
    ChatView()
}
