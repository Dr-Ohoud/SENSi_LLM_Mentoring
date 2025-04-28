//
//  TextMarkdown.swift
//  SENSI
//
//  Created by Shahad Bagarish on 28/04/2025.
//

import SwiftUI

struct TextMarkdown: View {

    let markdown: LocalizedStringKey

    init(_ content: String) {
        markdown = LocalizedStringKey(content)
    }

    var body: some View {
       Text(markdown)
            .textSelection(.enabled)
    }
}
