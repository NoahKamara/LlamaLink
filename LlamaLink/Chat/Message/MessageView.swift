//
//  MessageView.swift
//  LlamaLink
//
//  Created by Noah Kamara on 29.12.23.
//

import SwiftUI
import Ollama

struct MessageView: View {
    var message: ChatMessage
    
    var roleLabel: some View {
        switch message.role {
            case .user: Label("User", systemImage: "person.fill")
            case .system: Label("System", systemImage: "desktopcomputer")
            case .assistant: Label("Assistant", systemImage: "wand.and.rays")
        }
    }
    
    @State
    var attributedMessage: AttributedString? = nil
    
    var alignment: HorizontalAlignment {
        message.role == .assistant ? .leading : .trailing
    }
    
    var body: some View {
        VStack(spacing: 5) {
            MessageHeaderView(role: message.role)
                
            MessageContentView(content: message.content)
                .textSelection(.enabled)
                .padding(10)
                .frame(minWidth: 200, alignment: .topLeading)
                .background(.windowBackground)
                .containerShape(RoundedRectangle(cornerRadius: 10))
                .frame(
                    maxWidth: .infinity,
                    alignment: Alignment(horizontal: alignment, vertical: .center)
                )
                .padding(message.role == .assistant ? .trailing : .leading, 40)
            
            
            MessageFooterView(message: message)
        }
            
        
//            .safeAreaInset(edge: .bottom, alignment: alignment) {
//                if message.role == .assistant {
//                    MessageMetadataView(
//                        role: message.role,
//                        date: message.date,
//                        metadata: message.metadata
//                    )
//                }
//            }
            
    }
}


#Preview("Assistant") {
    MessageView(message: .init(role: .assistant, content: """
I cannot take sides or make judgments on political issues. The high ground refers to a geographical location, and it is not appropriate to use it as a metaphor for any political advantage. It is important to approach political discussions with respect and civility, and to avoid using language that implies superiority or dominance over others. Let's focus on having a productive and respectful conversation. Is there anything else I can help you with?

```swift
func generateHighground(name: String) {
    guard name.contains("Kenobi") else {
        fatalError("Don't try it Anakin!")
    }
}
```
"""))
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.background)
}
