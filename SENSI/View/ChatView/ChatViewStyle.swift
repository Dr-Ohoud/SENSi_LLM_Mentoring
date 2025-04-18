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
    @State private var alertMessage = ""
    @State private var isRecording = false

    @State private var milestoneSaved: Bool = false

    @State var registrationStep: Int = 7
    
    
    @EnvironmentObject var chatService: ChatServiceViewModel 
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        print(" The User: \(String(describing: viewModel.currentUser?.fullName))")
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
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("No message to undo"), message: Text("Text your mentor to get started"), dismissButton: .default(Text("Got it!")))
                        }
                        .disabled(registrationStep < 7 )
                        .opacity(registrationStep < 7 ? 0.3 : 1.0)
                        Spacer()
                        
                        Text("SENSI Mentor")
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
                                            extractMilestone(response: messages.dropLast().last?.text ?? "")
                                            
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
                            ChatInputMessages(
                                inputText: $inputText,
                                isLoading: $isLoading,
                                isRecording: $isRecording,
                                sendMessage: sendMessage)
                        }
                    }
                    
                    NavigationLink(destination: MailstonesView()
                        .navigationBarBackButtonHidden(false),
                                   isActive: $shouldNavigate) {
                        EmptyView() // Keeps it hidden but allows navigation
                    }.tint(.accent)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Undo"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .alert("Saving Milestone Error", isPresented: $milestoneSaved, actions: {
                    Button("OK", role: .cancel) {}
                }, message: {
                    Text("Milstone could not be saved. Please try again.")
                })
                .onAppear {
                    UNUserNotificationCenter.current().setBadgeCount(0)
                }
            }.tint(.accent)
        )
    }
}

extension ChatViewStyle {
    
    private func extractTitle(response: String) -> String {
        var title = "Untitled Milestone"
        
        let lines = response.components(separatedBy: .newlines)

        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if trimmed.lowercased().contains("**title:") {
                title = trimmed
                    .replacingOccurrences(of: "**Title:", with: "", options: .caseInsensitive)
                    .replacingOccurrences(of: "**", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                break
            } else if trimmed.lowercased().contains("### title:") {
                title = trimmed
                    .replacingOccurrences(of: "### title:", with: "", options: .caseInsensitive)
                    .replacingOccurrences(of: "**", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                break
            }
        }
        return title
    }
    
    private func extractMilestone(response: String) {
        let title = extractTitle(response: response)
        print(title)
        
        let lines = response.split(separator: "\n").map { String($0) }
        var extractedSteps: [String] = []
        
        for line in lines {
            if line.contains("**Step") {
                let step = line.replacingOccurrences(of: "**Step", with: "").trimmingCharacters(in: .whitespaces)
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
        print(milestone)
        print("✅ DEBUG: Extracted Milestone")
        
        chatService.saveMilestoneToFirebase(milestone: milestone)
    }
    
    private func undoLastMessage() {
        if messages.count >= 2 {
            if messages.count >= 3,
               messages.last?.text.contains("Would you like me to save this ") == true {
                messages.removeLast()
            }

            withAnimation {
                // Remove mentor message
                messages.removeLast()
                
                // Remove user message
                messages.removeLast()
            }
            alertMessage = "Last message removed."
            showingAlert = true

        } else {
            alertMessage = "No message to undo. Start chatting with your mentor first."
            showingAlert = true
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
    ChatViewStyle()
}
