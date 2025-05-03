//
//  RegistrationView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/03/2025.
//

import SwiftUI

struct RegistrationView: View {
    
    
    // MARK: - Send from chat view
    @Binding var step: Int
    @Binding var messages: [ChatMessage]
    @Binding var isLoading: Bool
    var onComplete: () -> Void
    
    @State private var registred: Bool = false
    @EnvironmentObject var viewModel: AuthViewModel
    
    // MARK: - Profile Data

    @State var fullName: String = ""
    @State var bio: String = ""
    @State var eduactionLevel: eduactionLevelEnums = .BachelorDegree
    @State var experienceLevel: experienceLevelEnums = .freshGraduateStudent
    @State var careerGoal: String = ""
    
    var email: String
    var password: String
    
    @State private var selectedEducation: eduactionLevelEnums? = nil
    @State private var selectedExperienceLevel: experienceLevelEnums? = nil
    
    @State var currentInput: String = ""
    @State var registerUser: String? = "No"
    @State private var shouldNavigate: Bool = false
    @State private var showAlert = false

    @Environment(\.dismiss) var dismiss
    

    
    var body: some View {
        NavigationStack {
            VStack{
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
                                options: ["Ok, Lets set the profile up!"],
                                selectedOption: $registerUser,
                                onSelect: { option in
                                    handleUserSelection(option)
                                }
                            )
                            
                        }
                        else {
                            TextField("Type a message...", text: $currentInput, axis: .vertical)
                                .textInputAutocapitalization(.sentences)
                                .disableAutocorrection(false)
                                .lineLimit(5)
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
                    
                }
                .padding()
                .onAppear() {
                    isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isLoading = false
                        withAnimation {
                            messages.append(ChatMessage(text: getRegistrationPrompt(), isUser: false))

                        }
                    }
                }
            }
            .alert("Registration Failed", isPresented: $registred) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Failed to create user, Try Again")
            }
            
            .alert("Registration Error", isPresented: $showAlert, actions: {
                Button("OK", role: .cancel) {
                    dismiss()
                }
            }, message: {
                Text("There is an error registering your account. Please try again.")
            })
//            .padding()
            .tint(.accent)
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
//        fakeLoadingAndProceed()
        
        // If we just completed step 6 and step is now 7, create user
            if step == 6 {
                step += 1 // manually move to step 7
                createUserProfile() // call user creation function
            } else {
                fakeLoadingAndProceed()
            }

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
            return
        default:
            break
        }
        fakeLoadingAndProceed()
        
    }
    
    private func getRegistrationPrompt() -> String {
        switch step {
        case 1: return
           """
Welcome to **SIGNUP** page 🌟! 
I am very happy to help you,

But first, can I know your name?
"""
        case 2: return "Now, I need to start with knowing about your education background?"
        case 3: return "What is you experience level?"
        case 4: return "What is your career goals? Example: I want to be Data Engineer "
        case 5: return "One more thing! help me to get know you by writing a short bio about yourself"
        case 6: return "What a great bio! First, Let me **create a profile** for you first to personalize and save your preferences"
        case 7: return "Thank you, \(viewModel.currentUser?.fullName ?? "") All set !! I appreciate your confidence in me!"
        default: return "Welcome!"
        }
    }
    
    private func createUserProfile() {
        isLoading = true
        Task {
            let success = try await viewModel.createUser(
                withEmail: email,
                password: password,
                fullName: fullName,
                bio: bio,
                eduactionLevel: eduactionLevel,
                experienceLevel: experienceLevel,
                careerGoal: careerGoal
            )
            isLoading = false
            if success {
                onComplete()
            } else {
                print("DEBUG: user registration failed, from RegistrationView")
                showAlert = true
            }
        }
    }
}

#if canImport(UIKit)
extension RegistrationView {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
