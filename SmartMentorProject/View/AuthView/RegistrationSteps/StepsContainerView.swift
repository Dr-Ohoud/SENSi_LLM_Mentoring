//
//  StepsContainerView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//


import SwiftUI

struct StepsContainerView: View {
    @State private var currentStep: Int = 1
    
    // MARK: - General Information
    @State var fullName: String = ""
    @State var bio: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var ConfirmPassword: String = ""
    
    // MARK: - User Background Section
    @State var eduactionLevel: eduactionLevelEnums = .BachelorDegree
    @State var skills: [String] = []
    @State var experienceLevel: experienceLevelEnums = .graduateStudent
    
    // MARK: - Career Aspirations Section
    @State var careerGoal: String = ""
    @State var interests: String = ""
    @State var skillGap: [String] = []
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack{
            progressBar
            
            switch currentStep {
                
                // MARK: - General Information
            case 1:
                StepOneView(
                    email: $email,
                    fullName: $fullName,
                    password: $password,
                    ConfirmPassword: $ConfirmPassword,
                    formIsValid: formIsValid,
                    onNext: { goToNextStep() }
                )
                // MARK: - User Background Section
            case 2:
                StepTwoView(
                    eduactionLevel: $eduactionLevel,
                    skills: $skills,
                    experienceLevel: $experienceLevel,
                    formIsValid: formIsValid,
                    onNext: { goToNextStep() },
                    onBack: { goToPreviousStep() }
                )
                // MARK: - Career Aspirations Section
            case 3:
                StepThreeView(
                    careerGoal: $careerGoal,
                    interests: $interests,
                    skillGap: $skillGap,
                    formIsValid: formIsValid,
                    onNext: { goToNextStep() },
                    onBack: { goToPreviousStep() }
                )
            case 4:
                StepFourView(
                    bio: $bio,
                    formIsValid: formIsValid,
                    onNext: { goToNextStep() },
                    onBack: { goToPreviousStep() }
                )
            default:
                Text("All steps complete!")
                    .foregroundColor(.black)
                
                
                Button {
                    Task {
                        try await viewModel.createUser(withEmail: email,
                                                       password: password,
                                                       fullName: fullName,
                                                       bio: bio,
                                                       eduactionLevel: eduactionLevel,
                                                       skills: skills,
                                                       experienceLevel: experienceLevel,
                                                       careerGoal: careerGoal,
                                                       interests: interests,
                                                       skillGap: skillGap)
                    }
                    dismiss()
                } label: {
                    HStack {
                        Text("SIGN UP")
                            .fontWeight(.bold)
                        Image(systemName: "arrow.right")
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    .background(.accent)
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                
            }
        }
        .padding(.horizontal, 16)
        
    }
    
    private var progressBar: some View {
        HStack {
            ForEach(1..<5) { stepIndex in
                Rectangle()
                    .fill(stepIndex <= currentStep ? .accent : Color.black.opacity(0.2))
                    .frame(height: 4)
                    .cornerRadius(2)
            }
        }
        .padding()
    }
    
    private func goToNextStep() {
        withAnimation {
            currentStep += 1
        }
    }
    
    private func goToPreviousStep() {
        withAnimation {
            currentStep -= 1
        }
    }
    
}

extension StepsContainerView:AuthintcationFormPrtotcol {
    var formIsValid: Bool {
        return !email.isEmpty
        && !email.contains("@")
        && !password.isEmpty
        && password.count < 6
        && ConfirmPassword == password
        && !skillGap.isEmpty
        && !interests.isEmpty
        && !careerGoal.isEmpty
        && !experienceLevel.rawValue.isEmpty
        && !eduactionLevel.rawValue.isEmpty
        && !skills.isEmpty
        && !bio.isEmpty
        && !fullName.isEmpty
        
    }
}

#Preview {
    StepsContainerView(
        fullName: "Shahad Abdullah",
        bio: "Aspiring Software Engineer | AI Enthusiast | Swiftui developer",
        email: "Shahad@gmail.com",
        password: "test",
        ConfirmPassword: "test",
        eduactionLevel: .BachelorDegree,
        skills: ["Swift Language", "Basic Coding"],
        experienceLevel: .seniorStudent,
        careerGoal: "Machine Learning Engineer",
        interests: "Machine Learning",
        skillGap: ["Python Language", "TensorFlow Framework"]
    )
}
