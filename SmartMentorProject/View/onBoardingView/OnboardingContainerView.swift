//
//  OnboardingContainerView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//


import SwiftUI

struct OnboardingContainerView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    @State private var currentStep: Int = 0
    @State private var onboardingSteps = [
        OnboardingSteps(id: UUID(), image: "LogoWithoutbacground", title: "SmartMentor", description: "", height: 100, width: 100),
        
        OnboardingSteps(id: UUID(), image: "LogoWithoutbacground", title: "Say Hello to your Mentor", description: "Your career guidence assistant", height: 100, width: 100),
        
        OnboardingSteps(id: UUID(), image: "", title: "Meet the AI Mentor that grows with you", description: "Learning and evolving with every interaction", height: 100, width: 100)
    ]
    
    var body: some View {
        
        VStack{
            HStack{
                Spacer()
                Button {
                    isOnboarding = false
                } label: {
                    Text("Skip")
                        .padding(16)
                        .foregroundStyle(.gray)
                }
                
            }
            TabView(selection: $currentStep){
                ForEach(onboardingSteps.indices, id: \.self) { index in
                    let step = onboardingSteps[index]
                    VStack {
                        OnboardingView(title: step.title, description: step.description, image: step.image, width: step.width, height: step.height)
                            .padding(30)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            HStack {
                ForEach(onboardingSteps.indices, id: \.self) { step in
                    if step == currentStep {
                        Rectangle()
                            .frame(width: 20, height: 10)
                            .cornerRadius(10)
                            .foregroundColor(.accent)
                    } else {
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.bottom, 24)
            
            Button(action: {
                if self.currentStep < onboardingSteps.count - 1 {
                    self.currentStep += 1
                } else {
                    isOnboarding = false
                }
                
            }, label: {
                Text(currentStep < onboardingSteps.count - 1 ? "Next" : "Get Started").frame(width: 300, height: 30)
                    .padding()
                    .background(.accent)
                    .cornerRadius(40)
                    .shadow(radius: 3)
                    .font(.headline)
                    .foregroundColor(Color.white)
                    .padding()
            })
            
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.white, .accent]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.5)
        )
    }
}

#Preview {
    OnboardingContainerView()
}


