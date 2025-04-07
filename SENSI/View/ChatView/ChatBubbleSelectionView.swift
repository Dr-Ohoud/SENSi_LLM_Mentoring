//
//  ChatBubbleSelectionView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 04/03/2025.
//

import SwiftUI

struct ChatBubbleSelectionView<T: Hashable & CustomStringConvertible>: View {
    let message: String
    let options: [T]
    @Binding var selectedOption: T?
    var onSelect: (T) -> Void // Callback when an option is selected

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            VStack(spacing: 8) {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        selectedOption = option
                        onSelect(option)
                    }) {
                        Text(option.description)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.green, lineWidth: 2)
                            )
                    }
                }
            }
            .frame(maxWidth: 300, alignment: .leading)
            .padding(.horizontal)
        }
    }
}
