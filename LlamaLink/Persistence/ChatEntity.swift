//
//  File.swift
//  LlamaLink
//
//  Created by Noah Kamara on 29.12.23.
//

import Foundation
import SwiftData

@Model
class ChatEntity {
    @Attribute
    var title: String?
    
    @Attribute
    var creationDate: Date
    
    @Relationship(deleteRule: .cascade)
    var messages: [MessageEntity]
    
    init(
        title: String?,
        creationDate: Date,
        messages: [MessageEntity] = []
    ) {
        self.title = title
        self.creationDate = creationDate
        self.messages = messages
    }
}
