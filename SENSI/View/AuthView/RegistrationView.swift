//
//  RegistrationView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/03/2025.
//

import SwiftUI

struct RegistrationView: View {
    
    @Binding var step: Int
    @Binding var messages: [ChatMessage]
    @Binding var isLoading: Bool
    
    
    @EnvironmentObject var viewModel: AuthViewModel
    @State var fullName: String = ""
    @State var bio: String = ""
    
    // MARK: - User Background Section
    @State var eduactionLevel: eduactionLevelEnums = .BachelorDegree
    @State var experienceLevel: experienceLevelEnums = .freshGraduateStudent
    
    // MARK: - Career Aspirations Section
    @State var careerGoal: String = ""
    
//    @State var userData = User()
    @State var currentInput: String = ""
    
    @State var registerUser: String? = "No"
    @State private var shouldNavigate: Bool = false
    
    @State private var selectedEducation: eduactionLevelEnums? = nil
    @State private var selectedExperienceLevel: experienceLevelEnums? = nil
    @Environment(\.dismiss) var dismiss
    
    var onComplete: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack{
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 3){
                        Text("Already have an account?")
                            .fontWeight(.medium)
                            .foregroundColor(.accent)
                        Text("Sign In")
                            .fontWeight(.bold)
                            .foregroundColor(.accent)
                    }
                    .font(.system(size: 14))
                }
                HStack {
                    HStack{
                        
                        if step == 2 {
                            ChatBubbleSelectionView(
                                message: getRegistrationPrompt(),
                                options: eduactionLevelEnums.allCases.filter { $0 != .none },
                                selectedOption: $selectedEducation,
                                onSelect: { option in
                                    handleUserSelection(option.rawValue)
                                }
                            )
                        } else if step == 3 {
                            ChatBubbleSelectionView(
                                message: getRegistrationPrompt(),
                                options: experienceLevelEnums.allCases.filter { $0 != .none },
                                selectedOption: $selectedExperienceLevel,
                                onSelect: { option in
                                    handleUserSelection(option.rawValue)
                                }
                            )
                        }  else if step == 6 {
                            ChatBubbleSelectionView(
                                message: getRegistrationPrompt(),
                                options: ["Yes", "No"],
                                selectedOption: $registerUser,
                                onSelect: { option in
                                    handleUserSelection(option)
                                    if option == "Yes" {
                                        registerUser = "No"
                                        shouldNavigate = true // Trigger navigation
                                        
                                    }
                                }
                            )
                            
                        }
                        else {
                            TextField(getRegistrationPrompt(), text: $currentInput)
                                .autocorrectionDisabled()
                        }
                        
                        Spacer()
                        ProgressView()
                            .opacity(isLoading ? 1 : 0)
                        
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal, 10)
                    
                    
                    if step == 1 || (step >= 4 && step != 6) {
                        AsyncButton {
                            await proceedToNextStep()
                        } label: {
                            Image(systemName: "paperplane.fill")
                                .padding()
                                .background(isLoading ? Color.gray : .accent)
                                .foregroundStyle(.white)
                                .cornerRadius(10)
                                .padding(.horizontal, 10)
                        }
                        .disabled(isLoading)
                    }
                    NavigationLink(destination: SignUpView(fullName: $fullName, bio: $bio, eduactionLevel: $eduactionLevel, experienceLevel: $experienceLevel, careerGoal: $careerGoal).navigationBarBackButtonHidden(false), isActive: $shouldNavigate) {
                        EmptyView() // Keeps it hidden but allows navigation
                    }.tint(.accent)
                }
                .padding()
                .onAppear() {
                    isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isLoading = false
                        messages.append(ChatMessage(text: getRegistrationPrompt(), isUser: false))
                    }
                }
            }
        }.tint(.accent)
    }
    private func fakeLoadingAndProceed() {
            isLoading = true // Show ProgressView
            
            // Simulate processing delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                isLoading = false // Hide ProgressView
                step += 1
                currentInput = ""
                messages.append(ChatMessage(text: getRegistrationPrompt(), isUser: false))
            }
        }
    
    private func handleUserSelection(_ response: String) {
        messages.append(ChatMessage(text: response, isUser: true))
        fakeLoadingAndProceed()

//        step += 1
//        currentInput = ""
//        messages.append(ChatMessage(text: getRegistrationPrompt(), isUser: false))
    }
    
    private func proceedToNextStep() async {
        let userResponse = currentInput.trimmingCharacters(in: .whitespaces)
        guard !userResponse.isEmpty else { return }
        
        messages.append(ChatMessage(text: userResponse, isUser: true))
        
        switch step {
        case 1:
            fullName = userResponse
        case 2:
            eduactionLevel = selectedEducation!
        case 3:
            experienceLevel = selectedExperienceLevel!
        case 4:
            careerGoal = userResponse
        case 5:
            bio = userResponse
        case 6:
            registerUser = userResponse
        case 7:
            onComplete()
            return
        default:
            break
        }
        fakeLoadingAndProceed()
        
    }
    
    private func getRegistrationPrompt() -> String {
        switch step {
        case 1: return "Welcome! I am very happy to help you but first let sign you up🌟. Can I know your name?" 
        case 2: return "Now, I need to start with knowing about your education background?"
        case 3: return "What is you experience level?"
        case 4: return "What is your career goals? Example: I want to be Data Engineer "
        case 5: return "One more thing! help me to get know you by writing a short bio about yourself"
        case 6: return "I am now ready to assist you. Would you like me to create a profile for you to personalize and save your preferences?"
        case 7: return "Thank you, \(viewModel.currentUser?.fullName ?? "") All set !! I appreciate your confidence in me!"
        default: return "Welcome!"
        }
    }
}
