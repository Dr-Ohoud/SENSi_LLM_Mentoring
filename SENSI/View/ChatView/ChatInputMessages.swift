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
    @Binding var isRecording: Bool
    
    var sendMessage: () async -> Void

    var body: some View {
        HStack {
            HStack{
                TextField("Type a message...", text: $inputText, axis: .vertical)
                    .textInputAutocapitalization(.sentences)
                    .disableAutocorrection(false)
                    .lineLimit(5)
                Spacer()
                ProgressView()
                    .opacity(isLoading ? 1 : 0)
//                MicButton(isRecording: isRecording, action: {
//                    startRecording()
//                })
                
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal, 10)
            
            HStack{
                
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
        }
        .padding()
    }
    func startRecording() {
        isRecording.toggle()
    }
}
