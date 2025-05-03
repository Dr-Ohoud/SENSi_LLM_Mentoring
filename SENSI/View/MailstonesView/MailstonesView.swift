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
                Text("Milestone Plan")
                    .frame(alignment: .leading)
                    .font(.title).bold()
                    .padding()
                if chatViewModel.isLoading {
                    LoadingView()
                    
                }  else if !chatViewModel.milestones.isEmpty {
                    ScrollView{
//                        GridItem(.flexible())
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(chatViewModel.milestones, id: \.id) { milestone in
                                
                                NavigationLink(destination: MilestoneDetailView(milestone: milestone)) {
                                    
                                    VStack{
                                        
                                        Text(milestone.title)
                                            .font(.headline)
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 5)
                                        
                                        Text("\(milestone.completedSteps.count) out of \(milestone.steps.count) steps")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        
                                        ProgressView(value: Float(milestone.completedSteps.count) / Float(milestone.steps.count))
                                            .progressViewStyle(LinearProgressViewStyle())
                                            .frame(width: 120)
                                        
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 2))
                                }
                            }
                        }
                        .padding()
                    }
                } else  {
                    Text("No Milestone Found")
                        .padding()
                        .font(.headline)
//                        .foregroundColor(.red)
                        .padding()
                }
                
                
                Spacer()
            }
        }
        .tint(.accent)
        .onAppear {
            chatViewModel.loadMilestone()
            chatViewModel.scheduleWeeklyReminderIfNeeded()
            UNUserNotificationCenter.current().setBadgeCount(0)
            
        }
    }
}



