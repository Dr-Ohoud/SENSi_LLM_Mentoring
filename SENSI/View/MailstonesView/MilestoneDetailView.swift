//
//  MilestoneDetailView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 12/03/2025.
//

import SwiftUI

//struct MilestoneDetailView: View {
//    var milestone: Milestone
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text(milestone.title)
//                .font(.title)
//                .bold()
//                .padding(.bottom, 10)
//            
//            Text("Steps to Complete")
//                .font(.headline)
//            
//            List(milestone.steps, id: \.self) { step in
//                HStack {
//                    Image(systemName: "circle.fill")
//                        .foregroundColor(.green)
//                    Text(step)
//                }
//            }
//            
//            Spacer()
//        }
//        .padding()
//        .navigationTitle("Milestone Details")
//    }
//}

struct MilestoneDetailView: View {
    @EnvironmentObject var chatViewModel: ChatServiceViewModel
    @State var milestone: Milestone

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(milestone.title)
                .font(.title2)
                .bold()
                .padding(.bottom, 10)

            Text("Steps to Complete")
                .font(.headline)

            List {
                ForEach(milestone.steps, id: \.self) { step in
                    HStack {
                        Image(systemName: milestone.completedSteps.contains(step) ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(milestone.completedSteps.contains(step) ? .green : .gray)
                        Text(step)
                    }
                    .onTapGesture {
                        toggleStep(step)
                    }
                }
            }

            Spacer()
        }
        .padding()
    }

    private func toggleStep(_ step: String) {
        if milestone.completedSteps.contains(step) {
            milestone.completedSteps.removeAll { $0 == step }
        } else {
            milestone.completedSteps.append(step)
        }

        Task {
            let _ = await chatViewModel.updateMilestoneCompletion(for: milestone)
        }
    }
}


