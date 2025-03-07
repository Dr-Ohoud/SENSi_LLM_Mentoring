//
//  ChatView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//
import SwiftUI

struct ChatView: View {
    @State private var messages: [ChatMessage] = []
    @State private var inputText: String = ""
    @State private var isTyping: Bool = false
    @State private var responseText: String = ""
    @State private var isLoading: Bool = false
    
    let chatService: ChatServiceViewModel = ChatServiceViewModel()
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack{
            
            VStack {
                // MARK: - Top Bar
                HStack {
                    Button(action: {
                        // Handle undo action
                    }) {
                        Image(systemName: "arrow.uturn.backward")
//                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundColor(.accent)
                    }
                    
                    Spacer()
                    
                    Text("Smart Mentor")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    NavigationLink(destination:
                                    UserProfileView()
                        .navigationBarBackButtonHidden(false)) {
                            Image(systemName: "person.fill")
                                .font(.title2)
                                .foregroundColor(.accent)
                        }
                        .accentColor(.accent)
                }
                .padding()
                .background(Color(.systemGray6))
                
                // MARK: - Chat Messages
                VStack {
                    ScrollViewReader { proxy in
                        ScrollView {
                            ForEach(messages) { message in
                                HStack {
                                    if message.isUser {
                                        Spacer()
                                        Text(message.text)
                                            .padding()
                                            .background(.accent)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                            .frame(maxWidth: 500, alignment: .trailing)
                                    } else {
                                        Text(message.text)
                                            .padding()
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(10)
                                            .frame(maxWidth: 500, alignment: .leading)
                                        Spacer()
                                    }
                                }
                                .padding()
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
                    
                    HStack {
                        HStack{
                            TextField("Type a message...", text: $inputText)
                                .autocorrectionDisabled()
                            Spacer()
                            ProgressView()
                                .opacity(isLoading ? 1 : 0)
                            
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal, 10)
                        
                        
                        AsyncButton {
                            await sendMessage()
                        } label: {
                            Image(systemName: "paperplane.fill")
                                .padding()
                                .background(isLoading ? Color.gray : .accent)
                                .foregroundStyle(.white)
                                .cornerRadius(10)
                                .padding(.horizontal, 10)
                        }
                    }
                    .padding()
                }
                .padding(.top, 10)
            }
        }.tint(.accent)
    }
}

extension ChatView {
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
    }
}

#Preview {
    
    ChatView()
}
