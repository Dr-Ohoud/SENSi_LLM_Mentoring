//
//  OnboardingView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//

import SwiftUI

struct OnboardingView: View  {
    @State var title : String
    @State var description : String
    @State var image : String
    @State var width : CGFloat
    @State var height : CGFloat

    var body: some View {
            VStack {
                Spacer()
                
                Image(self.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: self.width, height: self.height)
                    .padding()
                Text(self.title)
                    .fontWeight(.heavy)
                    .font(.title2)
                    .font(.custom("sans-serif", size: 20))
                    .multilineTextAlignment(.center)
                    .padding(1)
                
                Text(self.description)
                    .font(.custom("sf-pro-text", size: 20))
                    .fontWeight(.heavy)
                    .font(.custom("sans-serif", size: 20))
                    .multilineTextAlignment(.center)
                    .padding(1)
                
                Spacer()
            }
    }
}


#Preview {
    OnboardingView(title: "Welcome to SENSI Mentor", description: "Platform that connects students with mentors who are available to help them with their studies.", image: "LogoWithoutbacground", width: 100, height: 100)
}
