//
//  StepThreeView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//


import SwiftUI

//Enable Permetions
struct StepThreeView: View {
    @Binding var careerGoal: String
    @Binding var interests: String
    @Binding var skillGap: [String]
    @State private var newSkill: String = ""
    
    var formIsValid: Bool
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
            }

            VStack{
                Text("What is your Career Goal ?")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true)
                
                InputView(text: $careerGoal,
                          title: "Career Goal",
                          placeholder: "Enter your Career Goal")
            }
            
            VStack{
                Text("What is your Interests ?")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true)
                
                InputView(text: $interests,
                          title: "Interests",
                          placeholder: "Enter your Interest")
            }
            
            VStack{
                Text("What is your Skill Gap you want to improve?")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack {
                    TextField("Enter a skill", text: $newSkill)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 5)
                        .disabled(skillGap.count >= 5) // Disable if 5 skills are added
                    
                    Button(action: addSkill) {
                        Text("Add")
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(skillGap.count >= 5 ? Color.gray : .accent)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(skillGap.count >= 5 || newSkill.isEmpty) // Disable button if no input or limit reached
                }

                List {
                    Section(header: Text("Your Skills")) {
                        ForEach(skillGap, id: \.self) { skill in
                            Text(skill)
                        }
                    }
                }
                .frame(height: 200)
                
                // Limit Message
                if skillGap.count >= 5 {
                    Text("You can only add up to 5 skills.")
                        .font(.footnote)
                        .foregroundColor(.red)
                }
            }

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
        }.padding()
    }
    
    private func addSkill() {
        guard !newSkill.isEmpty, skillGap.count < 5 else { return }
        skillGap.append(newSkill)
        newSkill = "" // Clear the input field
    }
}
