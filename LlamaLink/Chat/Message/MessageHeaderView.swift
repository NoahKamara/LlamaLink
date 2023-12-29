//
//  MessageHeaderView.swift
//  LlamaLink
//
//  Created by Noah Kamara on 29.12.23.
//

import SwiftUI
import Ollama

extension ChatRole {
    var label: Text {
        let text = switch self {
        case .user: "User"
        case .system: "System"
        case .assistant: "Assistant"
        }
        return Text(text)
    }
    
    var icon: Image {
        let systemName = switch self {
        case .user: "person.fill"
        case .system: "apple.terminal.fill"
        case .assistant: "wand.and.rays"
        }
        
        return Image(systemName: systemName)
    }
}

struct MessageHeaderView: View {
    let role: ChatRole
    
    
    
    var body: some View {
        HStack {
            FlipGroup(if: role == .assistant) {
                Spacer()
                FlipGroup(if: role == .assistant) {
                    role.label
                    role.icon
                        .frame(width: 28, height: 28)
                        .background(.windowBackground, in: Circle())
                }
                .font(.headline)
            }
        }
    }
}

#Preview("Assistant") {
    VStack {
        MessageHeaderView(role: .assistant)
        MessageHeaderView(role: .user)
        MessageHeaderView(role: .system)
    }
    .background(.background)
}
