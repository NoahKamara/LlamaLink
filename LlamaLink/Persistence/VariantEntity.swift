//
//  VariantEntity.swift
//  LlamaLink
//
//  Created by Noah Kamara on 29.12.23.
//

import Foundation
import SwiftData
import Ollama

@Model
class MessageVariantEntity {
    @Attribute
    var content: String
    
    @Attribute
    var date: Date
    
    @Relationship
    var original: MessageEntity?
    
    init(
        content: String,
        date: Date,
        original: MessageEntity? = nil
    ) {
        self.content = content
        self.date = date
        self.original = original
    }
}
