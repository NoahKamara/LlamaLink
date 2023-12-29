//
//  ChatBoxView.swift
//  MacAI
//
//  Created by Noah Kamara on 27.12.23.
//

import Foundation
import SwiftUI


struct ChatBoxButton<Content: View>: View {
    let content: Content
    
    init(content: Content) {
        self.content = content
    }
    
    init(@ViewBuilder content: () -> Content) {
        self.init(content: content())
    }
    
    var body: some View {
        content
            .frame(width: 45, height: 30)
            .foregroundStyle(.white)
            .background(Color.accentColor, in: ContainerRelativeShape())
            .fontWeight(.bold)
            .buttonStyle(.plain)
    }
}


enum SendMode: String, CaseIterable, Hashable {
    case send
    case append
    
    var label: Text {
        let val = switch self {
        case .send: "send"
        case .append: "append"
        }
        return Text(val)
    }
}

struct SendButtonOptions {
    var role: ChatRole
    var mode: SendMode
    
    init(role: ChatRole = .user, mode: SendMode = .send) {
        self.role = role
        self.mode = mode
    }
}

struct SendButton: View {
    @Environment(\.isEnabled)
    private var isEnabled
    
    var submit: () async throws -> Void
    
    func buttonAction() {
        Task {
            do {
                try await submit()
            } catch {
                print("FAILED")
            }
        }
    }
    
    @Binding
    var options: SendButtonOptions
    
    var body: some View {
        HStack(spacing: 1) {
            Button(action: buttonAction, label: {
                Group {
                    switch options.mode {
                        case .send: Image(systemName: "paperplane.fill")
                        case .append: Image(systemName: "text.append")
                    }
                }
                .frame(width: 45, height: 30)
                .background(in: Rectangle())
            })
            .buttonStyle(.plain)
            .contentTransition(.symbolEffect(.replace))
            .symbolEffect(.pulse, isActive: !isEnabled)
            
            Menu {
                Picker("Role", selection: $options.role) {
                    ForEach([ChatRole.user, .system], id:\.rawValue) { role in
                        Label(
                            title: { role.label },
                            icon: { role.icon }
                        )
                        .tag(role)
                    }
                }
                .pickerStyle(.inline)
                
                Picker("Send Mode", selection: $options.mode) {
                    ForEach(SendMode.allCases, id:\.rawValue) { mode in
                        mode.label
                            .tag(mode)
                    }
                }
                .pickerStyle(.inline)
            } label: {
                Image(systemName: "chevron.down")
                    .imageScale(.small)
                    .frame(width: 20, height: 30)
                    .contentShape(Rectangle())
            }
            .frame(width: 20, height: 30)
            .background(in: Rectangle())
        }
        .clipShape(ContainerRelativeShape())
        .foregroundStyle(.white)
        .backgroundStyle(
            options.role == .user ? Color.accentColor : .gray
        )
        .fontWeight(.bold)
        .buttonStyle(.plain)
        
//        Menu {
//            ChatBoxButton {
//                Image(systemName: "paperplane.fill")
//            }
//        } label: {
//            ChatBoxButton {
//                Image(systemName: "paperplane.fill")
//            }
//        } primaryAction: {
//            buttonAction()
//        }
        .menuStyle(.automatic)
        .buttonStyle(.plain)
    }
}

#Preview("Send Button") {
    @State var options = SendButtonOptions()
    
    return SendButton(submit: { }, options: $options)
        .containerShape(RoundedRectangle(cornerRadius: 10))
        .padding(20)
}

import OmenTextField
import Ollama

struct ChatBoxView: View {
    let chat: ChatModel
    
    @State
    var message: String = ""
    
    @Namespace
    private var namespace
    
    var actionBtn: some View {
        Button(action: {}, label: {
            ChatBoxButton {
                Image(systemName: "ellipsis")
            }
        })
        .buttonStyle(.plain)
        .matchedGeometryEffect(id: "actionBtn", in: namespace)
    }
    
    @State
    var isLoading: Bool = false
    
    @State
    var options = SendButtonOptions()
    
    func submit() async throws {
        defer { isLoading = false }
        
        isLoading = true
        
        // Create and add message to history
        let message = ChatMessage(
            role: options.role,
            content: message
        )
        print(message)
        self.message = ""
        chat.append(message)
        
        // if mode isnt send we're done here
        guard options.mode == .send else {
            return
        }
        
        // generate answer
        try await chat.generateAnswer()
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 5) {
            actionBtn
            
            TextField("Message", text: $message, axis: .vertical)
                .textFieldStyle(.plain)
                .scrollDisabled(true)
                .padding(7)
                .frame(maxWidth: .infinity, minHeight: 30)
                .background(.windowBackground)
                .onSubmit(of: .text) {
                    Task {
                        do {
                            try await submit()
                        } catch {
                            print("Failed")
                        }
                    }
                }
            
            SendButton(submit: submit, options: $options)
        }
        .frame(minHeight: 30)
        .containerShape(RoundedRectangle(cornerRadius: 10))
        .padding(8)
        .background(.background)
        .disabled(isLoading)
        .symbolEffect(.pulse, isActive: isLoading)
    }
}

#Preview {
    ChatBoxView(
        chat: ChatModel(
            model: "llama2:code",
            history: PreviewData.chatHistory
        )
    )
    .frame(maxHeight: .infinity)
}
