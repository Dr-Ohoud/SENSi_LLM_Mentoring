//
//  SignUpView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//

import SwiftUI

struct SignUpView: View {
    @State private var registred: Bool = false
    
    // MARK: - General Information
    @Binding var fullName: String
    @Binding var bio: String
    @State var email: String = ""
    @State var password: String = ""
    @State var ConfirmPassword: String = ""
    
    // MARK: - User Background Section
    @Binding var eduactionLevel: eduactionLevelEnums
    @Binding var experienceLevel: experienceLevelEnums
    
    // MARK: - Career Aspirations Section
    @Binding var careerGoal: String
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        return (
            NavigationStack {
                VStack {
                    Image("LogoWithoutbacground")
                        .resizable()
                        .scaledToFit()
                        .frame(width: .infinity)
                        .frame(height: 100)
                        .padding(.all, 45)
                    
                    VStack(spacing: 24) {
                        InputView(text: $email,
                                  title: "Email Address",
                                  placeholder: "Enter your Email")
                        .autocapitalization(.none)
                        
                        
                        InputView(text: $password,
                                  title: "Password",
                                  placeholder: "Enter your Password",
                                  isSecureField: true)
                        
                        InputView(text: $ConfirmPassword,
                                  title: "Confirm Password",
                                  placeholder: "Confirm your Password",
                                  isSecureField: true)
                        
                        // sign in button
                        Button(action: {
                            
                            Task {
                                registred = try await viewModel.createUser(withEmail: email, password: password, fullName: fullName, bio: bio, eduactionLevel: eduactionLevel, experienceLevel: experienceLevel, careerGoal: careerGoal)
                                
                                if registred {
                                    dismiss()
                                }
                            }
                            
                        }) {
                            if registred {
                                ProgressView()  // Show a loading spinner
                            } else {
                                HStack {
                                    Text("SIGN UP")
                                        .fontWeight(.bold)
                                    Image(systemName: "arrow.right")
                                }
                                .padding()
                                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                                .background(.accent)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            
                        }
                        .padding()
                        Spacer()
                        
                        // sign in button
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
                    }
                    .padding(.horizontal, 32)
                    .alert("Signup Failed", isPresented: $registred) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text("Failed to create user, Try Again")
                    }
                    
                }
            }
            
        )
    }
}

extension SignUpView:AuthintcationFormPrtotcol {
    var formIsValid: Bool {
        return !email.isEmpty
        && !email.contains("@")
        && !password.isEmpty
        && password.count < 6
        && ConfirmPassword == password
        && !careerGoal.isEmpty
        && !experienceLevel.rawValue.isEmpty
        && !eduactionLevel.rawValue.isEmpty
        && !bio.isEmpty
        && !fullName.isEmpty
        
    }
}
