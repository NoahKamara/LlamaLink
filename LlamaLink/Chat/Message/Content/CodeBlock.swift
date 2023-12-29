//
//  CodeBlock.swift
//  MacAI
//
//  Created by Noah Kamara on 27.12.23.
//

import SwiftUI
import MarkdownUI
import Splash

extension MessageContentView {
    struct CodeBlock: View {
        let config: CodeBlockConfiguration
        
        @State var isHovering: Bool = false
        
        var body: some View {
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading) {
                        Group {
                            if let language = config.language, !language.isEmpty {
                                Text(language)
                                
                            } else {
                                Text("Code")
                            }
                        }
                        .font(.headline)
                        
                        Text("AI-generated code. Review and use carefully. More info on FAQ.")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    CopyButton(config.content) {
                        Image(systemName: "doc.on.doc")
                            .padding(7)
                            .frame(width: 45, height: 30)
                            .background(.windowBackground)
                    }
                    .buttonStyle(.plain)
                    .opacity(isHovering ? 1 : 0)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                Divider()
                ScrollView(.horizontal, content: {
                    config.label
                        .safeAreaPadding(7)
                })
                
            }
            .background(.background)
            .frame(maxWidth: .infinity, alignment: .leading)
            .markdownMargin(top: .em(1), bottom: .em(1))
            .markdownTextStyle {
                FontFamily(.system(.monospaced))
                FontSize(.em(0.9))
            }
            .padding(.horizontal, -5)
            .onHover { isHovering = $0 }
        }
    }
}

//struct SplashSyntaxHighlighter: CodeSyntaxHighlighter {
//    func highlightCode(_ code: String, language: String?) -> Text {
//        let resource = Splash.Font.Resource.preloaded(.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .regular))
//        var font = Font(size: NSFont.smallSystemFontSize)
//        font.resource = resource
//        let theme = Theme.docC
//        let outputFormat = AttributedStringOutputFormat(theme: theme)
//        let highlighter = SyntaxHighlighter(format: outputFormat)
//        let string = highlighter.highlight(code)
//        return Text(AttributedString(string))
//    }
//}
//#Preview {
//    MarkdownStyle.CodeBlock()
//}

import MarkdownUI

struct TextOutputFormat: OutputFormat {
    private let theme: Splash.Theme
    
    init(theme: Splash.Theme) {
        self.theme = theme
    }
    
    func makeBuilder() -> Builder {
        Builder(theme: self.theme)
    }
}

extension TextOutputFormat {
    struct Builder: OutputBuilder {
        private let theme: Splash.Theme
        private var accumulatedText: [Text]
        
        fileprivate init(theme: Splash.Theme) {
            self.theme = theme
            self.accumulatedText = []
        }
        
        mutating func addToken(_ token: String, ofType type: TokenType) {
            let color = self.theme.tokenColors[type] ?? self.theme.plainTextColor
            self.accumulatedText.append(Text(token).foregroundColor(.init(color)))
        }
        
        mutating func addPlainText(_ text: String) {
            self.accumulatedText.append(
                Text(text).foregroundColor(.init(self.theme.plainTextColor))
            )
        }
        
        mutating func addWhitespace(_ whitespace: String) {
            self.accumulatedText.append(Text(whitespace))
        }
        
        func build() -> Text {
            self.accumulatedText.reduce(Text(""), +)
        }
    }
}



struct SplashCodeSyntaxHighlighter: CodeSyntaxHighlighter {
    private let syntaxHighlighter: SyntaxHighlighter<TextOutputFormat>
    
    init(theme: Splash.Theme) {
        self.syntaxHighlighter = SyntaxHighlighter(format: TextOutputFormat(theme: theme))
    }
    
    func highlightCode(_ content: String, language: String?) -> Text {
        guard language?.lowercased() == "swift" else {
            return Text(content)
        }
        
        return self.syntaxHighlighter.highlight(content)
    }
}

extension CodeSyntaxHighlighter where Self == SplashCodeSyntaxHighlighter {
    static func splash(theme: Splash.Theme) -> Self {
        SplashCodeSyntaxHighlighter(theme: theme)
    }
}
