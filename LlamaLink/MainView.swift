//
//  MainView.swift
//  LlamaLink
//
//  Created by Noah Kamara on 29.12.23.
//

import SwiftUI
import Ollama

struct MainView: View {
    var body: some View {
        NavigationSplitView {
            Text("Sidebar")
        } detail: {
            ChatView(chat: ChatModel(model: "llama2:chat"))
        }
    }
}

#Preview {
    MainView()
}
