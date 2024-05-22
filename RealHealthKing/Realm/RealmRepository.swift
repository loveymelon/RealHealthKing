//
//  RealmRepository.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/19/24.
//

import RealmSwift

final class RealmRepository {
    private let realm = try! Realm()
    
    func createItem(roomId: String) throws {
        
        do {
            try realm.write {
                let chatRoomModel = ChatRoomRealmModel(roomId: roomId)
                
                realm.add(chatRoomModel)
            }
        } catch {
            throw RealmError.createFail
        }
        
    }
    
    func fetchItem(roomId: String) -> List<ChatRealmModel> {
        
        print("abc")
        
        let roomObject = realm.objects(ChatRoomRealmModel.self).filter("id == %@", roomId)[0]
        
        print("dddd", realm.configuration.fileURL)
        
        return roomObject.chatmodel
        
    }
    
}
