//
//  CopyButton.swift
//  LlamaLink
//
//  Created by Noah Kamara on 29.12.23.
//

import SwiftUI

struct CopyButton<Label: View>: View {
    let content: String
    let label: Label
    
    init(
        _ content: String,
        label: Label
    ) {
        self.content = content
        self.label = label
    }
    
    init(
        _ content: String,
        @ViewBuilder label: () -> Label
    ) {
        self.init(content, label: label())
    }
    
    func action() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(content, forType: .string)
    }
    
    var body: some View {
        Button(action: action, label: {
            label
        })
    }
}

//#Preview {
//    CopyButton()
//}
