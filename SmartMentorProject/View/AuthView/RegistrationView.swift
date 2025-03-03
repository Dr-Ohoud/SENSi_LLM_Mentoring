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
    @State var userData = User()
    @State var currentInput: String = ""
    
    @State var registerUser: Bool = false
    @State private var selectedEducation: eduactionLevelEnums? = nil
    @State private var selectedExperienceLevel: experienceLevelEnums? = nil
    
        
    
    var onComplete: () -> Void
    
    var body: some View {
        HStack {
            HStack{
                
                if step == 2 {
                    //                        EducationSelectionView(selectedEducation: $selectedEducation)
                    ChatBubbleSelectionView(
                        message: getRegistrationPrompt(),
                        options: eduactionLevelEnums.allCases,
                        selectedOption: $selectedEducation,
                        onSelect: { option in
                            handleUserSelection(option.rawValue)
                        }
                    )
                } else if step == 3 {
                    ChatBubbleSelectionView(
                        message: getRegistrationPrompt(),
                        options: experienceLevelEnums.allCases,
                        selectedOption: $selectedExperienceLevel,
                        onSelect: { option in
                            handleUserSelection(option.rawValue)
                        }
                    )
                    //                    ExperienceSelectionView(selectedExperienceLevel: $selectedExperienceLevel)
                } else {
                    TextField(getRegistrationPrompt(), text: $currentInput)
                        .autocorrectionDisabled()
                    //                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    //                            .padding()
                }
                
                Spacer()
                ProgressView()
                    .opacity(isLoading ? 1 : 0)
                
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal, 10)
            
            
            
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
        }
        .padding()
        .onAppear() {
            messages.append(ChatMessage(text: "Welcome! I am very happy to help you and I will be available any time you need me 🌟", isUser: false))
            messages.append(ChatMessage(text: getRegistrationPrompt(), isUser: false))
        }
        
        
        //        VStack {
        //            HStack {
        //                if step == 2 {
        //                    VStack(alignment: .leading, spacing: 16) {
        //                        Text(getRegistrationPrompt())
        //                            .font(.headline)
        //                            .padding(.bottom, 8)
        //
        //                        ForEach(eduactionLevelEnums.allCases) { option in
        //                            Button(action: {
        //                                selectedEducation = option
        //                            }) {
        //                                Text(option.rawValue)
        //                                    .frame(maxWidth: .infinity)
        //                                    .padding()
        //                                    .background(selectedEducation == option ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
        //                                    .foregroundColor(.black)
        //                                    .cornerRadius(8)
        //                                    .overlay(
        //                                        RoundedRectangle(cornerRadius: 8)
        //                                            .stroke(Color.green, lineWidth: 2)
        //                                    )
        //                            }
        //                        }
        //
        //                        if let selectedEducation = selectedEducation {
        //                            Text("You selected: \(selectedEducation.rawValue)")
        //                                .font(.subheadline)
        //                                .foregroundColor(.blue)
        //                                .padding(.top, 10)
        //                        }
        //                    }
        //                    .padding()
        //                } else if step == 3 {
        //                    VStack(alignment: .leading, spacing: 16) {
        //                        Text(getRegistrationPrompt())
        //                            .font(.headline)
        //                            .padding(.bottom, 8)
        //
        //                        ForEach(experienceLevelEnums.allCases) { option in
        //                            Button(action: {
        //                                selectedExperienceLevel = option
        //                            }) {
        //                                Text(option.rawValue)
        //                                    .frame(maxWidth: .infinity)
        //                                    .padding()
        //                                    .background(selectedExperienceLevel == option ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
        //                                    .foregroundColor(.black)
        //                                    .cornerRadius(8)
        //                                    .overlay(
        //                                        RoundedRectangle(cornerRadius: 8)
        //                                            .stroke(Color.green, lineWidth: 2)
        //                                    )
        //                            }
        //                        }
        //
        //                        if let selectedExperienceLevel = selectedExperienceLevel {
        //                            Text("You selected: \(selectedExperienceLevel.rawValue)")
        //                                .font(.subheadline)
        //                                .foregroundColor(.blue)
        //                                .padding(.top, 10)
        //                        }
        //                    }
        //                    .padding()
        //                }
        //                else {
        //                    TextField(getRegistrationPrompt(), getRegistrationPrompt())
        //                        .autocorrectionDisabled()
        //                }
        //                AsyncButton {
        //                    await proceedToNextStep()
        //                } label: {
        //                    Image(systemName: "paperplane.fill")
        //                        .padding()
        //                        .background(isLoading ? Color.gray : .accent)
        //                        .foregroundStyle(.white)
        //                        .cornerRadius(10)
        //                        .padding(.horizontal, 10)
        //                }
        //
        //                //                Button(action: proceedToNextStep) {
        //                //                    Image(systemName: "arrow.right.circle.fill")
        //                //                        .foregroundColor(.accent)
        //                //                        .font(.title2)
        //                //                }
        //            }
        //            .padding()
        //            .background(Color.gray.opacity(0.1))
        //            .cornerRadius(10)
        //            .padding(.horizontal, 10)
        //        }
        //        .padding()
    }
    
    private func handleUserSelection(_ response: String) {
            // Append user selection as a new chat message
            messages.append(ChatMessage(text: response, isUser: true))
            step += 1 // Move to the next step
        currentInput = ""
            messages.append(ChatMessage(text: getRegistrationPrompt(), isUser: false))
        }
    
    // Registration Steps
    private func proceedToNextStep() async {
        let userResponse = currentInput.trimmingCharacters(in: .whitespaces)
        guard !userResponse.isEmpty else { return }
        
        messages.append(ChatMessage(text: userResponse, isUser: true))
        
        switch step {
        case 1:
            userData.fullName = userResponse
        case 2:
            userData.eduactionLevel = selectedEducation!
        case 3:
            userData.experienceLevel = selectedExperienceLevel!
        case 4:
            userData.careerGoal = userResponse
        case 5:
            userData.bio = userResponse
        case 6:
            registerUser = true
            onComplete()
            return
        default:
            break
        }
        
        step += 1
        currentInput = ""
        messages.append(ChatMessage(text: getRegistrationPrompt(), isUser: false))
    }
    
    private func getRegistrationPrompt() -> String {
        switch step {
        case 1: return "Can I know your name to kick off? "
        case 2: return "Now, I need to start with knowing about your education background?"
        case 3: return "What is you experience level?"
        case 4: return "What is your career goals? "
        case 5: return "One more thing! help me to get know you by writing a short bio about yourself"
        case 6: return "Thank you, \(viewModel.currentUser?.fullName ?? "")! I am now ready to assist you. Would you like me to create a profile for you to personalize and save your preferences?"
        default: return "I appreciate your confidence in me! Let me know how I can assist you today."
        }
    }
}

// MARK: - Education Selection View
struct EducationSelectionView: View {
    @Binding var selectedEducation: eduactionLevelEnums
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Now, I need to start with knowing about your education background?")
                .font(.headline)
                .padding(.bottom, 8)
            
            ForEach(eduactionLevelEnums.allCases) { option in
                Button(action: {
                    selectedEducation = option
                }) {
                    Text(option.rawValue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedEducation == option ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.green, lineWidth: 2)
                        )
                }
            }
        }
        .padding()
    }
}

// MARK: - Experience Selection View
struct ExperienceSelectionView: View {
    @Binding var selectedExperienceLevel: experienceLevelEnums
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("What is your experience level?")
                .font(.headline)
                .padding(.bottom, 8)
            
            ForEach(experienceLevelEnums.allCases) { option in
                Button(action: {
                    selectedExperienceLevel = option
                }) {
                    Text(option.rawValue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedExperienceLevel == option ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.green, lineWidth: 2)
                        )
                }
            }
        }
        .padding()
    }
}
