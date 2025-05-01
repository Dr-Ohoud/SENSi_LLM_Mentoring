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
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (spacing: 24){
                    Image("LogoWithoutbacground")
                        .resizable()
                        .scaledToFit()
                        .frame(width: .infinity)
                        .frame(height: 100)
                        .padding(.all, 45)
                    
                    InputView(text: $email,
                              title: "Email Address",
                              placeholder: "Enter your Email")
                    .autocapitalization(.none)
                    
                    // Email Feedback
                    if !email.isEmpty && (!email.contains("@") || !email.contains(".")) {
                        Text("Please enter a valid email address.")
                            .font(.caption)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    InputView(text: $password,
                              title: "Password",
                              placeholder: "Enter your Password",
                              isSecureField: true)
                    
                    if !password.isEmpty && password.count < 6 {
                        Text("Password must be at least 6 characters.")
                            .font(.caption)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    
                    ZStack(alignment: .trailing){
                        InputView(text: $ConfirmPassword,
                                  title: "Confirm Password",
                                  placeholder: "Confirm your Password",
                                  isSecureField: true)
                        
                        if !ConfirmPassword.isEmpty {
                            if password == ConfirmPassword {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    Button {
                        Task {
                            registred = try await viewModel.createUser(withEmail: email, password: password, fullName: fullName, bio: bio, eduactionLevel: eduactionLevel, experienceLevel: experienceLevel, careerGoal: careerGoal)
                            
                            if registred {
                                dismiss()
                            }
                        }
                    } label: {
                        HStack {
                            Text("SIGN UP")
                                .fontWeight(.bold)
                            Image(systemName: "arrow.right")
                        }
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(.accent)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                    }
                    .disabled(!formIsValid)
                    .opacity(!formIsValid ? 0.5 : 1)
                    
                    Divider()
                    NavigationLink(destination:
                                    LoginView()
                        .navigationBarBackButtonHidden(true)) {
                            HStack(spacing: 3){
                                Text("Already have an account?")
                                    .fontWeight(.medium)
                                    .foregroundColor(.accent)
                                Text("Sign In")
                                    .fontWeight(.bold)
                                    .foregroundColor(.accent)
                            }
                            .font(.system(size: 14))
                            .foregroundColor(.accent)
                        }
                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 32)
                .alert("Registration Error", isPresented: $showAlert, actions: {
                    Button("OK", role: .cancel) {
                        dismiss()
                    }
                }, message: {
                    Text("There is an error registering your account. Please try again.")
                })
                .alert("Signup Failed", isPresented: $registred) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text("Failed to create user, Try Again")
                }
            }
            .tint(.accent)
            .onTapGesture { hideKeyboard() }
        }
    }
    
    func registerUser(email: String, password: String) {
        Task {
            registred = try await viewModel.createUser(withEmail: email, password: password, fullName: fullName, bio: bio, eduactionLevel: eduactionLevel, experienceLevel: experienceLevel, careerGoal: careerGoal)
            
            if registred == false{
                showAlert = true
            }
        }
    }
}

extension SignUpView:AuthintcationFormPrtotcol {
    var formIsValid: Bool {
        return !email.isEmpty &&
        email.contains("@") &&
        email.contains(".") &&
        !password.isEmpty &&
        password.count >= 6
        && ConfirmPassword == password
    }
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
