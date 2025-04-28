////
////  LoginViewNew.swift
////  SENSI
////
////  Created by Shahad Bagarish on 27/04/2025.
////
//
//import SwiftUI
//
//public struct LoginViewNew: View {
//    @Binding var step: Int
//    @Binding var messages: [ChatMessage]
//    @Binding var isLoading: Bool
//    
//    @EnvironmentObject var viewModel: AuthViewModel
//    @State var email: String = ""
//    @State var password: String = ""
//    @State var registrationStep: Int = 1
//    
//    //    @State var userData = User()
//    @State var currentInput: String = ""
//    
////    @State var loggedUser: String? = "No"
//    @State private var shouldNavigate: Bool = false
//    
//    
//    @State private var showAlert = false
//    @State private var alertMessage = ""
//    @Environment(\.dismiss) var dismiss
//    
//    var onComplete: () -> Void
//    
//    public var body: some View {
//        NavigationStack {
//            VStack{
//                // sign up button
//                NavigationLink(destination:
//                                ChatViewStyle(loggedUser: false, registrationStep: registrationStep)
//                    .navigationBarBackButtonHidden(true)) {
//                        HStack(spacing: 3){
//                            Text("Don't have an account?")
//                                .fontWeight(.medium)
//                                .foregroundColor(.accent)
//                            Text("Sign Up")
//                                .fontWeight(.bold)
//                                .foregroundColor(.accent)
//                        }
//                        .font(.system(size: 14))
//                    }
//                
////                Button {
////                    dismiss()
////                } label: {
////                    HStack(spacing: 3){
////                        Text("Don't have an account?")
////                            .fontWeight(.medium)
////                            .foregroundColor(.accent)
////                        Text("Sign Up")
////                            .fontWeight(.bold)
////                            .foregroundColor(.accent)
////                    }
////                    .font(.system(size: 14))
////                }
//                HStack {
//                    HStack{
//                        if step == 2 {
//                            SecureField("Type a message...", text: $currentInput)
//                            
//                        } else {
//                            
//                            TextField("Type a message...", text: $currentInput, axis: .vertical)
//                                .textInputAutocapitalization(.sentences)
//                                .disableAutocorrection(false)
//                                .lineLimit(5)
//                        }
//                        
//                        Spacer()
//                        ProgressView()
//                            .opacity(isLoading ? 1 : 0)
//                        
//                    }
//                    .padding()
//                    .background(Color.gray.opacity(0.1))
//                    .cornerRadius(10)
//                    .padding(.horizontal, 10)
//                    
//                    
//                    if step == 1 || (step >= 4 && step != 6) {
//                        AsyncButton {
//                            await proceedToNextStep()
//                        } label: {
//                            Image(systemName: "paperplane.fill")
//                                .padding()
//                                .background(isLoading ? Color.gray : .accent)
//                                .foregroundStyle(.white)
//                                .cornerRadius(10)
//                                .padding(.horizontal, 10)
//                        }
//                        .disabled(isLoading)
//                    }
//                    
//                    //                    NavigationLink(destination: LoginView(email: $email, password: $password)
//                    //                        .navigationBarBackButtonHidden(false), isActive: $shouldNavigate) {
//                    //                        EmptyView() // Keeps it hidden but allows navigation
//                    //                    }.tint(.accent)
//                }
//                .padding()
//                .onAppear() {
//                    isLoading = true
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        isLoading = false
//                        withAnimation {
//                            messages.append(ChatMessage(text: getLogeinPrompt(), isUser: false))
//                            
//                        }
//                    }
//                }
//            }
//            .alert("Login Error", isPresented: $showAlert, actions: {
//                Button("OK", role: .cancel) {}
//            }, message: {
//                Text("Email or Password is incorrect")
//            })
//            
//        }.tint(.accent)
//        
//    }
//    private func fakeLoadingAndProceed() {
//        isLoading = true // Show ProgressView
//        
//        // Simulate processing delay
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            isLoading = false // Hide ProgressView
//            step += 1
//            currentInput = ""
//            messages.append(ChatMessage(text: getLogeinPrompt(), isUser: false))
//        }
//    }
//    
//    private func handleUserSelection(_ response: String) {
//        messages.append(ChatMessage(text: response, isUser: true))
//        fakeLoadingAndProceed()
//        
//    }
//    
//    private func proceedToNextStep() async {
//        let userResponse = currentInput.trimmingCharacters(in: .whitespaces)
//        guard !userResponse.isEmpty else { return }
//        
//        messages.append(ChatMessage(text: userResponse, isUser: true))
//        
//        switch step {
//        case 1:
//            email = userResponse
//        case 2:
//            password = userResponse
//        case 3:
//            authenticateUser(email: email, password: password)
//            return
//        default:
//            break
//        }
//        fakeLoadingAndProceed()
//        
//    }
//    
//    private func getLogeinPrompt() -> String {
//        switch step {
//        case 1: return
//           """
//Welcome to SENSI!
//Let me **LOGIN** your account first so I can help guide you through your profile data.
//
//What is your Email?
//"""
//        case 2: return "Enter Your password, please"
//        default: return "Welcome!"
//        }
//    }
//    
//    func authenticateUser(email: String, password: String) {
//        Task {
//            alertMessage = try await viewModel.signIn(withEmail: email, password: password)
//            if alertMessage.contains("DEBUG:"){
//                showAlert = true
//            }
//        }
//    }
//}
//extension LoginViewNew: AuthintcationFormPrtotcol {
//    var formIsValid: Bool {
//        return !email.isEmpty &&
//        email.contains("@") &&
//        email.contains(".") &&
//        !password.isEmpty &&
//        password.count >= 6
//    }
//}
//
//#if canImport(UIKit)
//extension LoginViewNew {
//    func hideKeyboard() {
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
//}
//#endif
