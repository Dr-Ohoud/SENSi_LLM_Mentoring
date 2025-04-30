//
//  MilestoneDetailView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 12/03/2025.
//

import SwiftUI

struct MilestoneDetailView: View {
    @EnvironmentObject var chatViewModel: ChatServiceViewModel
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var milestone: Milestone
    @State private var isEditing = false
    @State private var title: String = ""
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if isEditing {
                TextField(milestone.title, text: $title, axis: .vertical)
                    .textInputAutocapitalization(.sentences)
                    .disableAutocorrection(false)
                    .lineLimit(5)
            } else {
                Text(milestone.title)
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 10)
            }
            Text("Steps to Complete")
                .font(.headline)
            
            List(milestone.steps, id: \.self) { step in
                HStack {
                    Image(systemName: milestone.completedSteps.contains(step) ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(milestone.completedSteps.contains(step) ? .green : .gray)
                    TextMarkdown(step)
                }
                .onTapGesture {
                    toggleStep(step)
                }
            }
            //            List {
            //                ForEach(milestone.steps, id: \.self) { step in
            //
            //                }
            //            }
            
            Spacer()
        }
        
        .navigationBarItems(trailing: HStack(spacing: 16){
            Button(action: {
                Task {
                    if isEditing {
                        await chatViewModel.updateMilestoneTitle(id: milestone.id, newTitle: title)
                        milestone.title = title // Update local view state
                    }
                    withAnimation {
                        isEditing.toggle()
                    }
                }}) {
                    Text(isEditing ? "Save" : "Edit Title")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(isEditing ? Color.accent : Color.black)
                }
            Button(action: {
                showDeleteConfirmation = true
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .font(.system(size: 14, weight: .semibold))
            }
            //                Button(action: {
            //                    Task {
            //                        await chatViewModel.deleteMilestone(withId: milestone.id)
            //                        withAnimation {
            //                            dismiss()
            //                        }
            //                    }
            //                }) {
            //                    Image(systemName: "trash")
            //                        .foregroundColor(.red)
            //                        .font(.system(size: 14, weight: .semibold))
            //                }
            
        })
        .padding()
        
        .onAppear() {
            self.title = milestone.title
        }
        .alert("Are you sure you want to delete this milestone?", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                Task {
                    await chatViewModel.deleteMilestone(withId: milestone.id)
                    withAnimation {
                        dismiss()
                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
    
    private func toggleStep(_ step: String) {
        if milestone.completedSteps.contains(step) {
            milestone.completedSteps.removeAll { $0 == step }
        } else {
            milestone.completedSteps.append(step)
        }
        
        Task {
            let updated = await chatViewModel.updateMilestoneCompletion(for: milestone)
            
            // ✅ Check if all steps are complete and schedule notification
            if updated && milestone.completedSteps.count == milestone.steps.count {
                NotificationManager.shared.scheduleNotification(
                    title: "🎯 You did it!",
                    body: "You've completed your milestone. Check with SENSI what is the next step!")
            }
        }
    }
    
}




