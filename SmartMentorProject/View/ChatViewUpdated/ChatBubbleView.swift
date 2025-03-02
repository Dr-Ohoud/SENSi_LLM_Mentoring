//
//  ChatBubbleView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 24/02/2025.
//

import SwiftUI

struct ChatBubbleView: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                Text(message.text)
                    .padding()
                    .background(.accent)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .frame(maxWidth: 500, alignment: .trailing)
            } else {
                Text(message.text)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .frame(maxWidth: 500, alignment: .leading)
                Spacer()
            }
        }
        .padding()
    }
}

#Preview {
    ChatBubbleView(message: ChatMessage(text: "Hello!", isUser: true))
}
