//
//  SettingsRowView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//

import SwiftUI

struct SettingsRowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.black)
        }
    }
}


#Preview {
    SettingsRowView(imageName: "gear", title: "Vesrion", tintColor: Color(.systemGray))
}
