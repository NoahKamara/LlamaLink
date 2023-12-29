//
//  MessageFooterView.swift
//  LlamaLink
//
//  Created by Noah Kamara on 29.12.23.
//

import SwiftUI
import Ollama

struct MessageFooterView: View {
    let message: ChatMessage
    
    var isFlipped: Bool {
        message.role == .assistant
    }
    
    var body: some View {
        HStack {
            FlipGroup(if: isFlipped) {
                Spacer()
                HStack {
                    FlipGroup(if: isFlipped) {
                        ShareLink(
                            item: message.content,
                            preview: SharePreview("LLama Chat Message")
                        )
                        
                        CopyButton(message.content) {
                            Image(systemName: "doc.on.doc")
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .labelStyle(.iconOnly)
                .imageScale(.small)
                .foregroundStyle(Color.accentColor)
            }
        }
        .padding(.horizontal, 5)
    }
}

//#Preview {
//    MessageFooterView(message: <#ChatMessage#>)
//}
