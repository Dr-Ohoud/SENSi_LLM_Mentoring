//
//  AuthViewModel.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

protocol AuthintcationFormPrtotcol {
    var formIsValid: Bool { get }
}
@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User? //Firebase auth Model
    @Published var currentUser: User? //My Model
    @Published var isLoading = false
    
    init() {
        // From Firebase
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: Failed to login user: \(error.localizedDescription)")

        }
    }
    
    func createUser(withEmail email: String, password: String, fullName: String, bio: String, eduactionLevel: eduactionLevelEnums, experienceLevel: experienceLevelEnums, careerGoal: String ) async throws -> Bool{
        DispatchQueue.main.async {
                self.isLoading = true
            }
            
        print("DEBUG: Attempting to create user with email \(email)")

            print("DEBUG: \(fullName) and \(email) and \(password) and bio \(bio) and eduaction Level is \(eduactionLevel) and experience Level \(experienceLevel) and career Goal \(careerGoal) are saved")
            do {
                let result = try await Auth.auth().createUser(withEmail: email, password: password)
                self.userSession = result.user
                print("DEBUG: Firebase Auth success - UID: \(result.user.uid)")

                // Double-check authentication
                guard let user = Auth.auth().currentUser else {
                    print("DEBUG: No authenticated user found after signup")
                    return false
                }
                print("DEBUG: Authenticated user found - UID: \(user.uid)")
                
                let userData = User(id: user.uid,
                                fullName: fullName,
                                email: email,
                                bio: bio,
                                eduactionLevel: eduactionLevel,
                                experienceLevel: experienceLevel,
                                careerGoal: careerGoal
                )
                let encodeUser = try Firestore.Encoder().encode(userData)
                print("DEBUG: Attempting to write to Firestore with data: \(encodeUser)")

                try await Firestore.firestore()
                    .collection("users")
                    .document(user.uid)
                    .setData(encodeUser)
                
                print("DEBUG: Successfully stored user in Firestore")

                await fetchUser()
                      
                      return true
                  } catch {
                      print("DEBUG: Failed to create user: \(error.localizedDescription)")
                      return false
                  }
        }
    
//    func createUser(withEmail email: String, password: String, fullName: String, bio: String, eduactionLevel: eduactionLevelEnums, experienceLevel: experienceLevelEnums, careerGoal: String) async throws -> Bool {
//        
//        print("DEBUG: \(fullName) and \(email) and \(password) and bio \(bio) and eduaction Level is \(eduactionLevel) and experience Level \(experienceLevel) and career Goal \(careerGoal) are saved")
//        do {
//            let result = try await Auth.auth().createUser(withEmail: email, password: password)
//            self.userSession = result.user
//            let user = User(id: result.user.uid,
//                            fullName: fullName,
//                            email: email,
//                            bio: bio,
//                            eduactionLevel: eduactionLevel,
////                            skills: skills,
//                            experienceLevel: experienceLevel,
//                            careerGoal: careerGoal,
////                            interests: interests,
////                            skillGap:skillGap,
//                            password: password,
//                            confirmPassword: password
//            )
//            let encodeUser = try Firestore.Encoder().encode(user)
//            try await Firestore.firestore().collection("users").document(result.user.uid).setData(encodeUser)
//            await fetchUser()
//            return true
//            
//        } catch {
//            print("DEBUG: Failed to create user: \(error.localizedDescription)")
//            return false
//        }
//    }
//    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.currentUser = nil
            self.userSession = nil
            
        } catch {
            print("DEBUG: failed to sign out with error: \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() {
        
    }
    
    func fetchUser() async {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
            
            self.currentUser = try? snapshot.data(as: User.self )
            print("DEBUg: Fetched user \(String(describing: self.currentUser))")
        }
    
//    func fetchUser() async {
//        guard let user = Auth.auth().currentUser else { return }
//        let userID = user.uid
//        guard let snapshot = try? await Firestore.firestore().collection("users").document(userID).getDocument() else { return }
//        
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
//        
//        self.currentUser = try? snapshot.data(as: User.self )
//        print("DEBUg: Fetched user \(String(describing: self.currentUser))")
//    }
}
