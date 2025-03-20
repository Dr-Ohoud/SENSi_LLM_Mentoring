//
//  UserProfileView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//

import SwiftUI

struct UserProfileView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            NavigationStack{
                List {
                    // MARK: - Header
                    Section{
                        HStack {
                            Text(user.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 72, height: 72)
                                .background(Color(.systemGray3))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.fullName)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                
                                Text(user.bio)
                                    .font(.footnote)
                                    .accentColor(.gray)
                            }
                        }
                    }
                    // MARK: - General Information
                    Section("General Information"){
                        HStack {
                            SettingsRowView(
                                imageName: "envelope",
                                title: "Email",
                                tintColor: Color(.systemGray)
                            )
                            Spacer()
                            Text(user.email)
                                .foregroundColor(.secondary)
                                .accentColor(.gray)
                        }
                    }
                    // MARK: - Mailstones
                    Section("Saved Mailstones"){
                        HStack {
                            SettingsRowView(
                                imageName: "target",
                                title: "",
                                tintColor: Color(.systemGray)
                            )
                            Spacer()
                            NavigationLink {
                                MailstonesView()
                                    .navigationBarBackButtonHidden(false)
                            } label: {
                                Text("Mailstones Page")
                                    .foregroundColor(.accent)
                                    .accentColor(.accent)
                            }

                           
                        }
                    }
                    
                    // MARK: - User Background Section
                    Section("User Background") {
                        
                        HStack {
                            SettingsRowView(
                                imageName: "graduationcap",
                                title: "Education Level",
                                tintColor: Color(.systemGray)
                            )
                            Spacer()
                            Text("\(user.eduactionLevel)")
                                .foregroundColor(.secondary)
                                .accentColor(.gray)
                        }
                        
                        //                    HStack (alignment: .top){
                        //                        SettingsRowView(
                        //                            imageName: "pencil.and.outline",
                        //                            title: "User Skills",
                        //                            tintColor: Color(.systemGray)
                        //                        )
                        //                        Spacer()
                        //                        VStack(alignment: .leading){
                        //                            ForEach(user.skills, id: \.self) { skils in
                        //                                Text(skils)
                        //                                    .foregroundColor(.secondary)
                        //                                    .accentColor(.gray)
                        //                            }
                        //                        }
                        //                    }
                        HStack {
                            SettingsRowView(
                                imageName: "person.fill",
                                title: "Experience Level",
                                tintColor: Color(.systemGray)
                            )
                            Spacer()
                            Text("\(user.experienceLevel)")
                                .foregroundColor(.secondary)
                                .accentColor(.gray)
                        }
                    }
                    
                    // MARK: - Career Aspirations Section
                    Section("Career Aspirations") {
                        
                        HStack {
                            SettingsRowView(
                                imageName: "target",
                                title: "Career Goal",
                                tintColor: .blue
                            )
                            Spacer()
                            Text(user.careerGoal)
                                .foregroundColor(.secondary)
                                .accentColor(.gray)
                        }
                        
                        //                    HStack (alignment: .top){
                        //                        SettingsRowView(
                        //                            imageName: "chart.bar.fill",
                        //                            title: "Skill Gap Analysis",
                        //                            tintColor: .red
                        //                        )
                        //                        Spacer()
                        //                        VStack(alignment: .leading){
                        //                            ForEach(user.skillGap, id: \.self) { skillGap in
                        //                                Text(skillGap)
                        //                                    .foregroundColor(.secondary)
                        //                                    .accentColor(.gray)
                        //                            }
                        //                        }
                        //                    }
                        //                    HStack {
                        //                        SettingsRowView(
                        //                            imageName: "star.fill",
                        //                            title: "Interests",
                        //                            tintColor: .yellow
                        //                        )
                        //                        Spacer()
                        //                        Text(user.interests)
                        //                            .foregroundColor(.secondary)
                        //                            .accentColor(.gray)
                        //                    }
                    }
                    
                    // MARK: - Account
                    Section("Account"){
                        Button {
                            viewModel.signOut()
                        } label: {
                            SettingsRowView(
                                imageName: "arrow.left.circle.fill",
                                title: "Sign out",
                                tintColor: Color(.red))
                        }
                        
//                        Button {
//                            print("Delete Account  ... ")
//                        } label: {
//                            SettingsRowView(
//                                imageName: "xmark.circle.fill",
//                                title: "Delete Account",
//                                tintColor: Color(.red))
//                        }
                    }
                }
            }
        }
    }
}




#Preview {
    UserProfileView()
}
