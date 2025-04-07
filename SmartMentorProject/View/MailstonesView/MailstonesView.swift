//
//  MailstonesView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 11/03/2025.
//
import SwiftUI

struct MailstonesView: View {
    
    @EnvironmentObject var chatViewModel: ChatServiceViewModel
    @State private var selectedMilestone: Int? = nil
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Milestone")
                    .frame(alignment: .leading)
                    .font(.title).bold()
                    .padding()
                if chatViewModel.isLoading {
                    LoadingView()
                    
                } else if chatViewModel.milestones.isEmpty {
                    Text("No Milestone Found")
                        .padding()
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(chatViewModel.milestones, id: \.id) { milestone in
                            NavigationLink(destination: MilestoneDetailView(milestone: milestone)) {
                                
                                VStack {
                                    
                                    Text(milestone.title)
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 5)
                                    
                                    Text(" \(milestone.steps.count) steps")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    ProgressView(value: Float(milestone.completedSteps.count) / Float(milestone.steps.count))
                                        .progressViewStyle(LinearProgressViewStyle())
                                        .frame(width: 120)
                                    
                                }
                                .padding()
                                .frame(width: 150, height: 150)
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 2))
                            }
                        }
                    }
                    .padding()
                }
                
                
                Spacer()
            }
        }
        .tint(.accent)
        .onAppear {
            chatViewModel.loadMilestone()
        }
    }
}



