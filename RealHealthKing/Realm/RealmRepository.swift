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
        
        if realm.objects(ChatRoomRealmModel.self).filter("roomId == %@", roomId).isEmpty {
            do {
                
                try realm.write {
                    let chatRoomModel = ChatRoomRealmModel(roomId: roomId)
                    
                    realm.add(chatRoomModel)
                }
                
            } catch {
                
                throw RealmError.createFail
                
            }
        }
        
    }
    
    func createChatItems(roomId: String, chatModel: ChatHistoryModel, isUser: Bool) throws {
        
        do {
            
            let roomObject = realm.objects(ChatRoomRealmModel.self).filter("roomId == %@", roomId)
            
            guard let date = chatModel.createdAt.toDate() else { return }
            
            try realm.write {
                let chatData = ChatRealmModel(id: chatModel.chatId, date: date, textContent: chatModel.content, imageContent: chatModel.files, isUser: isUser)
                
                realm.add(chatData)
            }
            
        } catch {
            
            throw RealmError.createFail
            
        }
        
    }
    
    func fetchItem(roomId: String) -> Results<ChatRoomRealmModel> {
        
        let roomObject = realm.objects(ChatRoomRealmModel.self).filter("roomId == %@", roomId)
        
        print("dasfadsf")
        print("dddd", realm.configuration.fileURL)
        
        return roomObject
        
    }
    
}
