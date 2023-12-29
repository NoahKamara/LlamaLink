//
//  MessageContentView.swift
//  LlamaLink
//
//  Created by Noah Kamara on 29.12.23.
//

import SwiftUI
import MarkdownUI
import Splash

struct MessageContentView: View {
    let content: String
    
    var body: some View {
        Markdown(content)
            
//            .markdownCodeSyntaxHighlighter(SplashSyntaxHighlighter())
            .markdownBlockStyle(\.codeBlock) { (configuration: CodeBlockConfiguration) in
                CodeBlock(config: configuration)
                    .markdownCodeSyntaxHighlighter(.splash(theme: .sundellsColors(withFont: .init(size: NSFont.systemFontSize))))
            }
            .markdownTheme(.docC)
            .lineSpacing(5)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.leading)
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
}
