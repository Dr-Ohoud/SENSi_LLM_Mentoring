//
//  TypingIndicatorView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 24/02/2025.
//

import SwiftUI

struct TypingIndicatorView: View {
    var body: some View {
        HStack {
            Text("Mentor is typing...")
                .italic()
                .foregroundColor(.gray)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    TypingIndicatorView()
}
