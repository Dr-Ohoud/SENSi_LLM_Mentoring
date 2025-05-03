//
//  SignUpView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    
    @Binding var email: String
    @Binding var password: String
    @Binding var ConfirmPassword: String
    @State var registrationStep: Int = 1
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var shouldNavigate: Bool = false
    
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
                    VStack (spacing: 24){
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
                                do {
                                    try await Auth.auth().createUser(withEmail: email, password: password)
                                    try await Auth.auth().currentUser?.delete()
                                    viewModel.isLoading = true
                                    shouldNavigate = true
                                    
                                } catch let error as NSError {
                                    if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                                        alertMessage = "This email is already associated with an account. Please use another one or sign in."
                                        showAlert = true
                                    } else {
                                        alertMessage = error.localizedDescription
                                        showAlert = true
                                    }
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
                    }
                    
                    Divider()
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
                        .foregroundColor(.accent)
                    }

                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 32)
                .alert("Registration Error", isPresented: $showAlert, actions: {
                    Button("OK", role: .cancel) {
                    }
                }, message: {
                    Text(alertMessage)
                })
                
                NavigationLink(
                    destination: ChatViewStyle(
                        registrationStep: registrationStep,
                        email: email,
                        password: password
                    ).navigationBarBackButtonHidden(true),
                    isActive: $shouldNavigate
                ) {
                    EmptyView()
                }
            }
        }
        .tint(.accent)
        .onTapGesture { hideKeyboard() }
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
