//
//  RealmRepository.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/19/24.
//

import RealmSwift

final class RealmRepository {
    
    var notificationToken: NotificationToken?
    
    private let realm = try! Realm()
    
    func createChatRoom(roomId: String) throws {

        do {
            
            try realm.write {
                let chatRoomModel = ChatRoomRealmModel(roomId: roomId)
                
                realm.add(chatRoomModel, update: .modified)
            }
            
        } catch {
            
            throw RealmError.createFail
            
        }
        
    }
    
    func createChatItems(roomId: String, chatModel: ChatHistoryModel, isUser: Bool) throws {
        
        do {
            
            let roomObject = realm.objects(ChatRoomRealmModel.self).filter("roomId == %@", roomId)

            guard let date = chatModel.createdAt.toDate() else { return }
            
            try realm.write {
                let chatData = ChatRealmModel(id: chatModel.chatId, date: date, textContent: chatModel.content, imageContent: chatModel.files, isUser: isUser)
                
                roomObject[0].chatmodel.append(chatData)

                realm.add(roomObject)
                
            }
            
        } catch {
            print("error")
            throw RealmError.createFail
            
        }
        
    }
    
    func fetchItem(roomId: String) -> [ChatRoomRealmModel] {
        
        print("fetch")
        
        let roomObject = realm.objects(ChatRoomRealmModel.self).filter("roomId == %@", roomId)
        
        print("dddd", realm.configuration.fileURL)
        
        return Array(roomObject)
        
    }
    
    func startNotification(roomId: String, completionHandler: @escaping (Result<[ChatRealmModel], Error>) -> Void) {
        
        let chatObject = realm.object(ofType: ChatRoomRealmModel.self, forPrimaryKey: roomId)
        
        guard let chatData = chatObject else { return }
        
        notificationToken = chatData.chatmodel.observe { changes in
            switch changes {
            case .initial(let data):
                completionHandler(.success(Array(data)))
            case .update(let data, _, _, _):
                completionHandler(.success(Array(data)))
            case .error(let error):
                completionHandler(.failure(error))
            }
        }
        
    }
    
}
