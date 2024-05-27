//
//  aaa.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/27/24.
//

import Foundation
import RxSwift
import RxCocoa

class aaa {
    var roomId = PublishRelay<Bool>()
    
    let realmRepository = RealmRepository()
    
    init() {
        roomId.flatMap { _ in
            
        }
    }
    
    func enterChatRoom() {
        let data = realmRepository.fetchItem(roomId: roomId)
        
        if data.isEmpty {
            NetworkManager.fetchChatMessage(roomId: roomId, cursor: "").flatMap { result in
                switch result {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        let a = 5
        
        
    }
    
    
}
