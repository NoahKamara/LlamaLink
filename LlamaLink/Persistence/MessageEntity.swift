//
//  MessageEntity.swift
//  LlamaLink
//
//  Created by Noah Kamara on 29.12.23.
//

import Foundation
import SwiftData
import Ollama

@Model
class MessageEntity {
    typealias Role = ChatRole
    
    @Attribute
    var role: Role
    
    @Attribute
    var content: String
    
    @Attribute
    var date: Date
    
//    @Attribute
//    var metadata: Metadata? = nil
    
    @Relationship
    var chat: ChatEntity?
    
    init(
        role: Role,
        content: String,
        date: Date,
        chat: ChatEntity? = nil
    ) {
        self.role = role
        self.content = content
        self.date = date
        self.chat = chat
    }
}
