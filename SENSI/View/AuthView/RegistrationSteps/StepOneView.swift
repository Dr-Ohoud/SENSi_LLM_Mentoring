//
//  StepOneView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//

import SwiftUI

//Get Name
struct StepOneView: View {
    @Binding var email: String
    @Binding var fullName: String
    @Binding var password: String
    @Binding var ConfirmPassword: String
    var formIsValid: Bool
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    let onNext: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Registration Form")
                    .font(.headline)
                
                Image("LogoWithoutbacground")
                    .resizable()
                    .scaledToFit()
                    .frame(width: .infinity)
                    .frame(height: 100)
                    .padding(.all, 45)
                
                VStack(alignment: .leading, spacing: 24) {
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
                    
                    ZStack(alignment: .trailing){
                        InputView(text: $ConfirmPassword,
                                  title: "Confirm Password",
                                  placeholder: "Confirm your Password",
                                  isSecureField: true)
                        if !password.isEmpty &&  !ConfirmPassword.isEmpty {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemRed))
                        }
                    }
                    
                    Spacer()
                }
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
            
            
            Spacer()
            
            // Next button at the bottom
            Button(action: onNext) {
                Text("Next")
                    .frame(width: 300, height: 30)
                    .padding()
                    .background(.accent)
                    .cornerRadius(40)
                    .shadow(radius: 3)
                    .font(.headline)
                    .foregroundColor(Color.white)
                    .padding()
            }
        }
    }
}


