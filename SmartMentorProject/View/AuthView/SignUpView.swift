//
//  SignUpView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//

import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var fullName: String = ""
    @State private var password: String = ""
    @State private var ConfirmPassword: String = ""
    
    @Environment(\.dismiss) var dismiss
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
                
                VStack(spacing: 24) {
                    InputView(text: $email,
                              title: "Email Address",
                              placeholder: "Enter your Email")
                    .autocapitalization(.none)
                    
                    InputView(text: $fullName,
                              title: "Full Name",
                              placeholder: "Enter your Name")
                    
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
//                            try await viewModel.createUser(
//                                withEmail: email,
//                                password: password,
//                                fullName: fullName)
                        }
                    }) {
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
                
            }
        }
    }
}

#Preview {
    SignUpView()
}
