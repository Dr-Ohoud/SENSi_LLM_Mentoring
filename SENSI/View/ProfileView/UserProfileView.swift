//
//  UserProfileView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//

import SwiftUI

struct UserProfileView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isEditing = false
    @State var fullName: String = ""
    @State var email: String = ""
    @State var eduactionLevel: eduactionLevelEnums = .none
    @State var experienceLevel: experienceLevelEnums = .none
    @State var careerGoal: String = ""
    @State var bio: String = ""
    @State var skills: [String]?
    @State var newSkill: String = ""
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        if let user = viewModel.currentUser {
            NavigationStack {
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
                                if isEditing {
                                    TextField(user.fullName, text: $fullName)
                                        .textInputAutocapitalization(.words)
                                        .disableAutocorrection(false)
                                } else {
                                    Text(user.fullName)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .padding(.top, 4)
                                }
                                if isEditing{
                                    TextField(user.bio, text: $bio, axis: .vertical)
                                        .textFieldStyle(.roundedBorder)
                                        .textInputAutocapitalization(.words)
                                        .disableAutocorrection(false)
                                        .lineLimit(5)
                                } else {
                                    Text(user.bio)
                                        .font(.footnote)
                                        .accentColor(.gray)
                                }
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
                            if isEditing {
                                TextField(user.email, text: $email, axis: .vertical)
                                    .textFieldStyle(.roundedBorder)
                                    .textInputAutocapitalization(.words)
                                    .disableAutocorrection(false)
                                    .lineLimit(5)
                            } else {
                                Text(user.email)
                                    .foregroundColor(.secondary)
                                    .accentColor(.gray)
                            }
                            
                        }
                    }
                    // MARK: - Mailstones
                    Section("My Mailstones"){
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
                                Text("Mailstones Plan")
                                    .foregroundColor(.accent)
                                    .accentColor(.accent)
                            }
                        }
                    }
                    
                    // MARK: - User Background Section
                    Section("User Background") {
                        // MARK: -  Background Level
                        HStack {
                            SettingsRowView(
                                imageName: "graduationcap",
                                title: "Education Level",
                                tintColor: Color(.systemGray)
                            )
                            Spacer()
                            if isEditing {
                                Picker("Education Level", selection: $eduactionLevel) {
                                    ForEach(eduactionLevelEnums.allCases.filter { $0 != .none }, id: \.self) { level in
                                        Text("\(level)").tag(level)
                                            .font(.system(size: 17))
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 100)
                            } else {
                                Text("\(user.eduactionLevel)")
                                    .foregroundColor(.secondary)
                                    .accentColor(.gray)
                            }
                        }
                        
                        // MARK: -  User Skills
                        //                            if let userSkills = user.skills, !userSkills.isEmpty {
                        //                                ForEach(userSkills, id: \.self) { skill in
                        //                                    HStack {
                        //                                        SettingsRowView(
                        //                                            imageName: "pencil.and.outline",
                        //                                            title: "Skill",
                        //                                            tintColor: Color(.systemGray)
                        //                                        )
                        //                                        Spacer()
                        //                                        Text(skill)
                        //                                            .foregroundColor(.secondary)
                        //                                    }
                        //                                }
                        //                            } else {
                        //                                HStack {
                        //                                    SettingsRowView(
                        //                                        imageName: "pencil.and.outline",
                        //                                        title: "User Skills",
                        //                                        tintColor: Color(.systemGray)
                        //                                    )
                        //                                    Spacer()
                        //                                    Text("No skills added yet")
                        //                                        .foregroundColor(.secondary)
                        //                                }
                        //                            }
                        //                            if isEditing {
                        //                                HStack {
                        //                                    SettingsRowView(
                        //                                        imageName: "plus",
                        //                                        title: "Add Skill",
                        //                                        tintColor: Color.accent
                        //                                    )
                        //                                    Spacer()
                        //                                    TextField("Enter a skill", text: $newSkill)
                        //                                    Button("Add") {
                        //                                        if !newSkill.isEmpty {
                        //                                            if skills == nil { skills = [] }
                        //                                            skills?.append(newSkill)
                        //                                            newSkill = ""
                        //                                        }
                        //                                    }
                        //                                }
                        //                            }
                        
                        // MARK: -  Experience Level
                        HStack {
                            SettingsRowView(
                                imageName: "person.fill",
                                title: "Experience Level",
                                tintColor: Color(.systemGray)
                            )
                            Spacer()
                            if isEditing {
                                Picker("Experience Level", selection: $experienceLevel) {
                                    ForEach(experienceLevelEnums.allCases.filter { $0 != .none } , id: \.self) { level in
                                        Text("\(level)").tag(level)
                                            .font(.system(size: 17))
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 100)
                            } else {
                                Text("\(user.experienceLevel)")
                                    .foregroundColor(.secondary)
                                    .accentColor(.gray)
                            }
                            
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
                            if isEditing {
                                TextField(user.careerGoal, text: $careerGoal, axis: .vertical)
                                    .textFieldStyle(.roundedBorder)
                                    .textInputAutocapitalization(.words)
                                    .disableAutocorrection(false)
                                    .lineLimit(5)
                            } else {
                                Text(user.careerGoal)
                                    .foregroundColor(.secondary)
                                    .accentColor(.gray)
                            }
                            
                        }
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
                        if viewModel.isLoading {
                            LoadingView()
                        } else {
                            Button(action: {
                                showDeleteConfirmation = true
                            }) {
                                SettingsRowView(
                                    imageName: "person.fill.xmark",
                                    title: "Delete account",
                                    tintColor: Color(.red))
                            }
                        }
                    }
                    
                    
                }.alert("Are you sure you want to delete your account?", isPresented: $showDeleteConfirmation) {
                    Button("Delete", role: .destructive) {
                        Task {
                            let success = await viewModel.deleteAccount()
                            if success {
                                print("Account deleted.")
                            }
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                }
            }
            .onAppear {
                if fullName.isEmpty { fullName = user.fullName }
                if bio.isEmpty { bio = user.bio }
                if email.isEmpty { email = user.email }
                if eduactionLevel == .none { eduactionLevel = user.eduactionLevel }
                if experienceLevel == .none { experienceLevel = user.experienceLevel }
                if careerGoal.isEmpty { careerGoal = user.careerGoal }
                if skills == nil || skills?.isEmpty ?? true { skills = user.skills }
            }
            .navigationBarItems(trailing: HStack(spacing: 16){
                Button(action: {
                    if isEditing {
                        updateUserDataWrapper()
                    }
                    withAnimation {
                        isEditing.toggle()
                    }
                }) {
                    Text(isEditing ? "Save" : "Edit Profile")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(isEditing ? Color.accent : Color.black)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .padding(.top, 15)
                }
            })
        }
    }
    private func updateUserDataWrapper() {
        Task {
            await updateUserData()
        }
    }
    
    @MainActor
    private func updateUserData() async {
        guard var user = viewModel.currentUser else { return }
        
        if !fullName.isEmpty { user.fullName = fullName }
        if !bio.isEmpty { user.bio = bio }
        if !email.isEmpty { user.email = email }
        if eduactionLevel != .none { user.eduactionLevel = eduactionLevel }
        if experienceLevel != .none { user.experienceLevel = experienceLevel }
        if !careerGoal.isEmpty { user.careerGoal = careerGoal }
        
        if let updatedSkills = skills {
            user.skills = updatedSkills
        }
        
        await viewModel.updateUser(userUpdated: user)
    }
}




