//
//  ChatView.swift
//  LlamaLink
//
//  Created by Noah Kamara on 29.12.23.
//

import SwiftUI
import Ollama

struct ChatView: View {
    var chat = ChatModel(
        model: "llama2:chat"
    )
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if !chat.messages.isEmpty {
                    ForEach(chat.messages) { msg in
                        MessageView(message: msg.message)
                    }
                } else {
                    Text("No Messages")
                }
            }
            .padding()
        }
        .safeAreaInset(edge: .bottom, content: {
            ChatBoxView(chat: chat)
                .disabled(isLoading)
        })
        .background(.background)
        .task(priority: .userInitiated) {
            PreviewData.irishDev.forEach(chat.append)
            try? await chat.generateAnswer()
        }
    }
    
    @State var isLoading: Bool = false
    
    func submitMessage(content: String) {
        let msg = ChatMessage(role: .user, content: content)
    
        Task {
            isLoading = true
            do {
                try await chat.send(message: msg)
            } catch {
                print("ERROR", error)
            }
            isLoading = false
        }
    }
}

#Preview {
    ChatView(chat: ChatModel(model: "", history: PreviewData.chatHistory))
}

@Observable
class ChatModel {
    struct Message: Identifiable {
        let id: Int
        let message: ChatMessage
        var alternates: [Self] = []
    }
    
    private var chat: OllamaChatAPI {
        client.model(model).chat
    }
    var model: String
    private var client: Ollama
    
    private var history: [Message] = []
    private var streamingMessage: ChatMessage? = nil
    
    public var messages: [Message] {
        access(keyPath: \.history)
        access(keyPath: \.streamingMessage)
        if let streamingMessage {
            return history + [.init(id: history.count, message: streamingMessage)]
        } else {
            return history
        }
    }
    
    private var lock: Bool = false
    
    func append(_ message: ChatMessage) {
        withMutation(keyPath: \.messages) {
            withMutation(keyPath: \.history) {
                history.append(.init(id: history.count, message: message))
            }
        }
    }
    
    init(
        model: String,
        history: [ChatMessage] = [],
        client: Ollama = .default
    ) {
        self.model = model
        self.client = client
        
        
        withMutation(keyPath: \.messages) {
            self.history = history.reduce([Message](), { result, msg in
                let new = Message(id: result.count, message: msg)
                return result + [new]
            })
        }
    }
    
    func generateAnswer() async throws {
        let messageHistory = history.map(\.message)
        let chunks = try await chat.stream(messages: messageHistory)
        
        self.streamingMessage = .init(role: .assistant, content: "")
        
        for try await chunk in chunks {
            guard streamingMessage != nil else {
                print("NO MESSAGE PREPARED")
                return
            }
            
            withMutation(keyPath: \.streamingMessage) {
                self.streamingMessage?.content += chunk.message.content
            }
        }
        
        if let streamingMessage {
            withMutation(keyPath: \.streamingMessage) {
                withMutation(keyPath: \.history) {
                    history.append(.init(id: history.count, message: streamingMessage))
                    self.streamingMessage = nil
                }
            }
        }
    }
    
    func send(message: ChatMessage) async throws {
        append(message)
        try await generateAnswer()
    }
}


