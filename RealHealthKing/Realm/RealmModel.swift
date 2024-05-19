//
//  RealmModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/19/24.
//

import Foundation
import RealmSwift

class ChatRealmModel: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var chatRoom: List<ChatRoomRealmModel>
    
    convenience init(id: ObjectId) {
        self.init()
    }
}

class ChatRoomRealmModel: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var date: Date
    @Persisted var content: String
    @Persisted var isUser: Bool
    
    convenience init(id: String, date: Date, content: String, isUser: Bool) {
        self.init()
        
        self.id = id
        self.date = date
        self.content = content
        self.isUser = isUser
    }
}
