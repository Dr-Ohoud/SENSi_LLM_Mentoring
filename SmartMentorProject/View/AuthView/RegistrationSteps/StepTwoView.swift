//
//  StepTwoView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//

import SwiftUI

// MARK: - User Background Section
struct StepTwoView: View {
    
    @Binding var eduactionLevel: eduactionLevelEnums
    @Binding var skills: [String]
    @Binding var experienceLevel: experienceLevelEnums
    @State private var newSkill: String = ""
    var formIsValid: Bool
    
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack{
            
            Button(action: onBack) {
                Image(systemName: "chevron.left")
            }
            VStack{
                Text("What is your education level ?")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true)
                
                Picker("Education Level", selection: $eduactionLevel) {
                    ForEach(eduactionLevelEnums.allCases , id: \.self) { level in
                        Text("\(level)").tag(level)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 100)
            }
            Text("What is your experience level ?")
                .font(.subheadline)
                .foregroundColor(.black)
                .fixedSize(horizontal: false, vertical: true)
            
            Picker("Experience Level", selection: $experienceLevel) {
                ForEach(experienceLevelEnums.allCases , id: \.self) { level in
                    Text("\(level)").tag(level)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 100)
            
            VStack(spacing: 20) {
                Text("Add Your Skills")
                    .font(.subheadline)
                HStack {
                    TextField("Enter a skill", text: $newSkill)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 5)
                        .disabled(skills.count >= 5) // Disable if 5 skills are added
                    
                    Button(action: addSkill) {
                        Text("Add")
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(skills.count >= 5 ? Color.gray : .accent)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(skills.count >= 5 || newSkill.isEmpty) // Disable button if no input or limit reached
                }

                List {
                    Section(header: Text("Your Skills")) {
                        ForEach(skills, id: \.self) { skill in
                            Text(skill)
                        }
                    }
                }
                .frame(height: 200)
                
                // Limit Message
                if skills.count >= 5 {
                    Text("You can only add up to 5 skills.")
                        .font(.footnote)
                        .foregroundColor(.red)
                }
                
                Spacer()
            }
            .padding()
            Spacer()
            
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
    
    private func addSkill() {
        guard !newSkill.isEmpty, skills.count < 5 else { return }
        skills.append(newSkill)
        newSkill = "" // Clear the input field
    }
}

//#Preview {
//    
//    StepTwoView(eduactionLevel: .constant([.BachelorDegree, .masterDegree]), skills: .constant(["Swift Language", "Basic Coding"]), experienceLevel: .constant(.seniorStudent) )
//}
