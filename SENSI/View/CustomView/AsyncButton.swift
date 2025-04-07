//
//  AsyncButton.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//

import SwiftUI
import Foundation

public struct AsyncButton<Label: View>: View {
    let action: () async -> Void
    let label: Label
    
    @State private var isRunning: Bool = false
    
    init(
        action: @escaping () async -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.action = action
        self.label = label()
    }
    
    public var body: some View {
        Button {
            isRunning = true
            Task {
                await action()
                isRunning = false
            }
        } label: { label } .disabled(isRunning)
    }
}
