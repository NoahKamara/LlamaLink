//
//  TestTextField.swift
//  LlamaLink
//
//  Created by Noah Kamara on 29.12.23.
//

import SwiftUI
import OmenTextField

struct TestTextField: View {
    @State
    var message = """
Hello World, my name is Noah
"""
    var body: some View {
        OmenTextField("Message", text: $message)
    }
}

#Preview {
    TestTextField()
}
