//
//  RealmModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/19/24.
//

import Foundation
import RealmSwift

class RealmModel: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var date: Date
    @Persisted var content: String
    @Persisted var user: Bool
    
    convenience init(id: ObjectId, date: Date, content: String, user: Bool) {
        self.init()
        self.date = date
        self.content = content
        self.user = user
    }
}
