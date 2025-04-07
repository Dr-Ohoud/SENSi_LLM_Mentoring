//
//  UserProgressView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//

import SwiftUI

struct UserProgressView: View {
    @State private var tasks: [providedTasks] = [
        providedTasks(id: 1, title: "Learn Swift Basics", isCompleted: false, score: 0),
        providedTasks(id: 2, title: "Build a Simple iOS App", isCompleted: false, score: 0),
        providedTasks(id: 3, title: "Master Core ML Integration", isCompleted: false, score: 0),
        providedTasks(id: 4, title: "Learn Swift Basics", isCompleted: false, score: 0),
        providedTasks(id: 5, title: "Build a Simple iOS App", isCompleted: false, score: 0),
        providedTasks(id: 6, title: "Master Core ML Integration", isCompleted: false, score: 0)
    ]
    @State private var totalScore = 0
    @State private var maxScore = 600 // Example maximum score (100 points per task)
    
    
    var body: some View {
        // Career Plan Section
        VStack {
            // Profile Header
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray)
                    .padding()
                
                VStack(alignment: .leading) {
                    Text("Ahad")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text("0 Tasks Completed")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            VStack(alignment: .leading, spacing: 15) {
                Text("Career Plan")
                    .font(.headline)
                    .padding(.bottom, 8)
                
                VStack {
                    ProgressView(value: Double(totalScore), total: Double(maxScore))
                        .progressViewStyle(LinearProgressViewStyle(tint: .accent))
                        .padding(.horizontal)
                        .overlay(
                            Text("\(totalScore)/\(maxScore) Points")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        )
                }
                
                List {
                    ForEach(tasks) { task in
                        HStack {
                            Text(task.title)
                                .font(.body)
                            Spacer()
                            
                            if task.isCompleted {
                                Button(action: {
                                    notCompleteTask(task: task)
                                }) {
                                    Text("✔")
                                        .font(.footnote)
                                        .foregroundColor(.accentColor)
                                }                                    } else {
                                    Button(action: {
                                        completeTask(task: task)
                                    }) {
                                        Text("Mark Complete")
                                            .font(.footnote)
                                            .foregroundColor(.accentColor)
                                    }
                                }
                        }
                    }
                }
//                .frame(height: 250)
                .listStyle(InsetGroupedListStyle())
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 4)
            
            Spacer()
        }
    }
    // Function to Mark Task as Completed
    func completeTask(task: providedTasks) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted = !tasks[index].isCompleted
            tasks[index].score = 100 // Add points for the completed task
            totalScore += 100
        }
    }
    
    func notCompleteTask(task: providedTasks) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted = !tasks[index].isCompleted
            tasks[index].score = -100 // Add points for the completed task
            totalScore -= 100
        }
    }
}
#Preview {
    UserProgressView()
}

