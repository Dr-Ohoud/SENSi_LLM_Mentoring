//
//  LoadingView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 07/04/2025.
//

import SwiftUI

struct LoadingView: View {
    
    var body: some View {
        Spacer()
        HStack {
            Spacer()
            ProgressView("Loading ...")
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
            Spacer()
        }
        Spacer()
    }
}
