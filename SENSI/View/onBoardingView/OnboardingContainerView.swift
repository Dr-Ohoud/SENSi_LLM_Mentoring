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
        OnboardingSteps(id: UUID(),
                        image: "SENSI1",
                        title: "Welcome to SENSI 👋",
                        description: "Your personal career mentor — designed to guide you step-by-step through your learning and growth journey.", height: 300, width: 350),
        
        OnboardingSteps(id: UUID(),
                        image: "SENSI2",
                        title: "Personalized Guidance, Just for You",
                        description:
                        """
                        SENSI gives you:
                        Career advice tailored to your goals
                        Milestones to help you take action
                        Skill gap insights to grow faster
                        """
                        , height: 250, width: 350),
        
        OnboardingSteps(id: UUID(),
                        image: "SENSI3",
                        title: "Built by Mentors. Powered by AI.",
                        description: "SENSI is like having a career coach in your pocket — always there to support, guide, and motivate you", height: 300, width: 350)
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


