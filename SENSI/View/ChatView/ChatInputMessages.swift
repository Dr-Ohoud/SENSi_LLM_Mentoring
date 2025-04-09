//
//  ChatInputMessages.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/03/2025.
//

import SwiftUI

struct ChatInputMessages: View {
    @Binding var inputText: String
    @Binding var isLoading: Bool
    var sendMessage: () async -> Void

    var body: some View {
        HStack {
            HStack{
                TextField("Type a message...", text: $inputText, axis: .vertical)
                    .textInputAutocapitalization(.words)
                    .disableAutocorrection(false)
                    .lineLimit(5)
                Spacer()
                ProgressView()
                    .opacity(isLoading ? 1 : 0)
                
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal, 10)
            
            
            AsyncButton {
                await sendMessage()
            } label: {
                Image(systemName: "paperplane.fill")
                    .padding()
                    .background(isLoading ? Color.gray : .accent)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 10)
            }
        }
        .padding()
    }
}
