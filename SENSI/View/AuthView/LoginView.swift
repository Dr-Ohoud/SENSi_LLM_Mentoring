//
//  LoginView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State var registrationStep: Int = 1
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("LogoWithoutbacground")
                    .resizable()
                    .scaledToFit()
                    .frame(width: .infinity)
                    .frame(height: 100)
                    .padding(.all, 45)
                ScrollView {
                    VStack(spacing: 24) {
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
                        
                        // Password Feedback
                        if !password.isEmpty && password.count < 6 {
                            Text("Password must be at least 6 characters.")
                                .font(.caption)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                        
                        // sign in button
                        Button(action: {
                            authenticateUser(email: email, password: password)
                        }) {
                            HStack {
                                Text("SIGN IN")
                                    .fontWeight(.bold)
                                Image(systemName: "arrow.right")
                            }
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .background(.accent)
                            .disabled(formIsValid)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding()
                        .disabled(!formIsValid)
                        .opacity(!formIsValid ? 0.5 : 1)
                        Divider()
                        
                        // sign up button
                        NavigationLink(destination:
                                        ChatViewStyle(registrationStep: registrationStep)
                            .navigationBarBackButtonHidden(true)) {
                                HStack(spacing: 3){
                                    Text("Don't have an account?")
                                        .fontWeight(.medium)
                                        .foregroundColor(.accent)
                                    Text("Sign Up")
                                        .fontWeight(.bold)
                                        .foregroundColor(.accent)
                                }
                                .font(.system(size: 14))
                            }
                    }
                    .padding(.horizontal, 32)
                }
            }
            .onTapGesture { hideKeyboard() }
            .alert("Login Error", isPresented: $showAlert, actions: {
                Button("OK", role: .cancel) {}
            }, message: {
                Text("Email or Password is incorrect")
            })
        }
    }
    
    func authenticateUser(email: String, password: String) {
        Task {
            alertMessage = try await viewModel.signIn(withEmail: email, password: password)
            if alertMessage.contains("DEBUG:"){
                showAlert = true
            }
        }
    }
}

extension LoginView: AuthintcationFormPrtotcol {
    var formIsValid: Bool {
        return !email.isEmpty &&
        email.contains("@") &&
        email.contains(".") &&
        !password.isEmpty &&
        password.count >= 6
    }
}

#if canImport(UIKit)
extension LoginView {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

#Preview {
    LoginView()
}
