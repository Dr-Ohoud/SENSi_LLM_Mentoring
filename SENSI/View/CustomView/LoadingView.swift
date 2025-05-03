//
//  LoadingView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 07/04/2025.
//

import SwiftUI

//struct LoadingView: View {
//    
//    var body: some View {
//        Spacer()
//        HStack {
//            Spacer()
//            ProgressView("Loading ...")
//                .progressViewStyle(CircularProgressViewStyle())
//                .padding()
//            Spacer()
//        }
//        Spacer()
//    }
//}

struct LoadingView: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(.easeIn(duration: 0.5), value: isAnimating)

            VStack(spacing: 20) {
                Image(uiImage: UIImage(named: "LogoWithoutbacground")!)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .scaleEffect(isAnimating ? 1.1 : 0.9)
                    .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)

                Text("SENSI")
                    .font(.title)
                    .bold()
                    .foregroundColor(.gray)
                    .opacity(isAnimating ? 1.0 : 0.5)
                    .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isAnimating)

                Text("SENSI is loading...")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .opacity(0.7)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}
