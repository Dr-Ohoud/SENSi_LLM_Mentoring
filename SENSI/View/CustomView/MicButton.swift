//
//  MicButton.swift
//  SENSI
//
//  Created by Shahad Bagarish on 15/04/2025.
//

import SwiftUI

struct MicButton: View {
    var isRecording: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isRecording ? "mic.fill" : "mic")
                .font(.system(size: 24))
                .foregroundColor(.accent)
//                .padding()
//                .background(Circle().fill(Color.gray.opacity(0)))
        }
        .shadow(radius: isRecording ? 5 : 0)
    }
}
