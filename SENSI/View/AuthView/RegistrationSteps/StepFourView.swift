//
//  StepFourView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//

import SwiftUI

struct StepFourView: View {
    @Binding var bio: String
    var formIsValid: Bool
    
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        ZStack {
            // MARK: - Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                // MARK: - Nav / Back Button
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding()
                
                // MARK: - Title & Subtitle
                Spacer()
                
                Text("One more thing")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("Help Your Mentor get to know you by writing a short letter")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 4)
                
                // MARK: - Letter Card
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.white)
                        .frame(width: 300, height: 300)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        .rotationEffect(.degrees(-5))
                    
                    TextEditor(text: $bio)
                        .font(.body)
                        .foregroundColor(.primary)
                        .frame(width: 280, height: 280)
                        .rotationEffect(.degrees(-5))
                        .padding(.bottom, 10)  
                }
                .padding(.top, 20)
                
                Spacer()
                
                // MARK: - Bottom Button
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
            
            
        }.padding()
    }
}

