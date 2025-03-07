//
//  ChatBubbleView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 24/02/2025.
//

import SwiftUI

struct ChatBubbleView: View {
    let message: ChatMessage
    var onSelectOption: ((String) -> Void)? // Callback when an option is selected
    
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
                
                // Render options if present
                if let options = message.options {
                    VStack(spacing: 8) {
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                onSelectOption?(option)
                            }) {
                                Text(option)
                                    .padding()
                                    .frame(maxWidth: 250)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.green, lineWidth: 2)
                                    )
                            }
                        }
                    }
                    .frame(maxWidth: 300, alignment: .leading)
                }
                Spacer()
            }
        }
        .padding()
    }
}

#Preview {
    ChatBubbleView(message: ChatMessage(text: "Hello!", isUser: true))
}
