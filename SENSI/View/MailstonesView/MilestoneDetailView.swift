//
//  MilestoneDetailView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 12/03/2025.
//

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
                    Image(systemName: "circle.fill")
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


