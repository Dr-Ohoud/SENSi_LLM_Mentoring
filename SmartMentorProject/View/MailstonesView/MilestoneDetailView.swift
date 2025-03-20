//
//  MilestoneDetailView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 12/03/2025.
//

import SwiftUI

import SwiftUI

struct MilestoneDetailView: View {
    var milestone: Milestone

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(milestone.title)
                .font(.title)
                .bold()
                .padding(.bottom, 10)
            
            Text("Steps to Complete")
                .font(.headline)
            
            List(milestone.steps, id: \.self) { step in
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text(step)
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Milestone Details")
    }
}

//struct MilestoneDetailView: View {
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 60) {
//            VStack(spacing: 20) {
//                ForEach(1...4, id: \..self) { index in
//                    
//                        HStack {
//                            Circle()
//                                .stroke(Color.gray, lineWidth: 2)
//                                .frame(width: 50, height: 50)
//                                .overlay(Text("\(index)").bold())
//                            Spacer()
//                        }
//                }
//            }
//            Spacer()
//        }
//    }
//}


