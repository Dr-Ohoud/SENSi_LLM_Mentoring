//
//  RegistrationFlowView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 24/02/2025.
//

import SwiftUI

struct RegistrationFlowView: View {
    @Binding var step: Int
    @Binding var userData: UserData
    @Binding var messages: [ChatMessage]

    var onComplete: () -> Void

    var body: some View {
        VStack {
            HStack {
                TextField(getRegistrationPrompt(), text: $userData.currentInput)
                    .autocorrectionDisabled()
                
                Button(action: proceedToNextStep) {
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundColor(.accent)
                        .font(.title2)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal, 10)
        }
        .padding()
    }

    // Registration Steps
    private func proceedToNextStep() {
        let userResponse = userData.currentInput.trimmingCharacters(in: .whitespaces)
        guard !userResponse.isEmpty else { return }

        messages.append(ChatMessage(text: userResponse, isUser: true))

        switch step {
        case 1:
            userData.fullName = userResponse
        case 2:
            userData.educationLevel = userResponse
        case 3:
            userData.careerGoal = userResponse
        case 4:
            userData.bio = userResponse
            onComplete()
            return
        default:
            break
        }

        step += 1
        userData.currentInput = ""
        messages.append(ChatMessage(text: getRegistrationPrompt(), isUser: false))
    }

    private func getRegistrationPrompt() -> String {
        switch step {
        case 1: return "Welcome! What's your full name?"
        case 2: return "What's your education level?"
        case 3: return "What’s your career goal?"
        case 4: return "Tell me a bit about yourself in a short bio."
        default: return "You're all set! Let's start chatting."
        }
    }
}

#Preview {
    RegistrationFlowView(step: .constant(1), userData: .constant(UserData()), messages: .constant([]), onComplete: {})
}
