//
//  RealmModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/19/24.
//

import Foundation
import RealmSwift

class ChatRoomRealmModel: Object {
    @Persisted(primaryKey: true) var roomId: String
    @Persisted var chatmodel: List<ChatRealmModel>
    
    convenience init(roomId: String) {
        self.init()
        
        self.roomId = roomId
    }
}

class ChatRealmModel: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var date: Date
    @Persisted var textContent: String
    @Persisted var imageContent: List<String>
    @Persisted var isUser: Bool
    
    convenience init(id: String, date: Date, textContent: String, imageContent: [String], isUser: Bool) {
        self.init()
        
        self.id = id
        self.date = date
        self.textContent = textContent
        self.imageContent.append(objectsIn: imageContent)
        self.isUser = isUser
    }
}


