//
//  ChatInputView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 24/02/2025.
//

import SwiftUI

struct ChatInputView: View {
    @Binding var inputText: String
    @Binding var isLoading: Bool
    var sendMessage: () async -> Void

    var body: some View {
        HStack {
            TextField("Type a message...", text: $inputText)
                .autocorrectionDisabled()

            Button(action: { Task { await sendMessage() } }) {
                Image(systemName: "paperplane.fill")
                    .padding()
                    .background(.accent)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 10)
            }
        }
        .padding()
    }
}

#Preview {
    ChatInputView(inputText: .constant(""), isLoading: .constant(false), sendMessage: {})
}
