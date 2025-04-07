//
//  ChatHeaderView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 24/02/2025.
//

import SwiftUI

struct ChatHeaderView: View {
    var body: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "line.3.horizontal")
                    .font(.title2)
                    .foregroundColor(.accent)
            }
            Spacer()
            
            Text("Smart Mentor")
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
            
            NavigationLink(destination: UserProfileView()) {
                Image(systemName: "person.fill")
                    .font(.title2)
                    .foregroundColor(.accent)
            }
        }
        .padding()
        .background(Color(.systemGray6))
    }
}

#Preview {
    ChatHeaderView()
}
