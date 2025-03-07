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
                    
                    InputView(text: $password,
                              title: "Password",
                              placeholder: "Enter your Password",
                              isSecureField: true)
                    
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
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                        .background(.accent)
                        .disabled(formIsValid)
//                        .opacity(formIsValid ? 1.0 : 0.5)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding()
                    Spacer()
                    
                    // sign up button
                    NavigationLink(destination:
                                    ChatViewStyle(registrationStep: registrationStep)
//                                                            SignUpView()
//                                   StepsContainerView()
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
    }
    
    func authenticateUser(email: String, password: String) {
        Task{
            try await viewModel.signIn(withEmail: email, password: password)
        }
    }
}

extension LoginView:AuthintcationFormPrtotcol {
    var formIsValid: Bool {
        return !email.isEmpty
        && !email.contains("@")
        && !password.isEmpty
        && password.count < 6
    }
}

#Preview {
    LoginView()
}
