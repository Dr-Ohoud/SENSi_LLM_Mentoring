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
            
            do {
                let result = try await Auth.auth().createUser(withEmail: email, password: password)
                self.userSession = result.user
                print("DEBUG: Firebase Auth success - UID: \(result.user.uid)")

                // Double-check authentication
                guard let user = Auth.auth().currentUser else {
                    print("DEBUG: No authenticated user found after signup")
                    return false
                }
                
                let userData = User(id: user.uid,
                                fullName: fullName,
                                email: email,
                                bio: bio,
                                eduactionLevel: eduactionLevel,
                                experienceLevel: experienceLevel,
                                careerGoal: careerGoal
                )
                let encodeUser = try Firestore.Encoder().encode(userData)

                try await Firestore.firestore()
                    .collection("users")
                    .document(user.uid)
                    .setData(encodeUser)
                
                await fetchUser()
                      
                      return true
                  } catch {
                      print("DEBUG: Failed to create user: \(error.localizedDescription)")
                      return false
                  }
        }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.currentUser = nil
            self.userSession = nil
            
        } catch {
            print("DEBUG: failed to sign out with error: \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async {
            guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            
            if let data = snapshot.data() {
                do {
                    self.currentUser = try snapshot.data(as: User.self)
                    print("DEBUG: Fetched user \(String(describing: self.currentUser))")
                } catch {
                    print("Decoding Error: \(error.localizedDescription)")
                }
            } else {
                print("User document does not exist.")
            }
        } catch {
            print("Error fetching user: \(error.localizedDescription)")
        }
        
//            guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
            
//            self.currentUser = try? snapshot.data(as: User.self )
//            print("DEBUg: Fetched user \(String(describing: self.currentUser))")
        }

}
