//
//  ChatViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/17/24.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class ChatViewModel: ViewModelType {
    struct Input {
        let viewWillAppearTrigger: Observable<Void>
        let viewDidAppearTrigger: Observable<Void>
    }
    
    struct Output {
        let chatDatas: Driver<List<ChatRealmModel>>
    }
    
    private let realmRepository = RealmRepository()
    
    var roomId = ""
    var latestDate = ""
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        
        
        let chatDatasResult = PublishRelay<List<ChatRealmModel>>()
        
//        input.viewWillAppearTrigger.subscribe(with: self) { owner, roomId in
//            let data = owner.realmRepository.fetchItem(roomId: roomId)
//            
//            chatDatasResult.accept(data)
//        }.disposed(by: disposeBag)
        
//        input.viewWillAppearTrigger.withUnretained(self).flatMap { owner, roomId in
//            
//            if let model = owner.realmRepository.fetchItem(roomId: roomId).last {
//                return NetworkManager.fetchChatMessage(roomId: roomId, cursor: model.date.toString())
//            } else {
//                return NetworkManager.fetchChatMessage(roomId: roomId, cursor: Date().toString())
//            }
//            
//        }.subscribe(with: self) { owner, result in
//            
//            switch result {
//            case .success(let data):
//                print(data.data.count)
//            case .failure(let error):
//                print(error)
//            }
//            
//        }.disposed(by: disposeBag)
        
        input.viewWillAppearTrigger.withUnretained(self).flatMap { owner, _ in
            let data = owner.realmRepository.fetchItem(roomId: owner.roomId)
            
            if data.isEmpty {
                return NetworkManager.fetchChatMessage(roomId: owner.roomId, cursor: "")
            } else {
                SocketIOManager.shared.startNetwork(roomId: owner.roomId) { <#ChatRoomsModel#> in
                    <#code#>
                }
                return NetworkManager.fetchChatMessage(roomId: owner.roomId, cursor: data[0].chatmodel[0].date.toString())
            }
            
        }.subscribe(with: self) { owner, result in
            
            switch result {
                
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
                
            }
//            owner.latestDate = data[0].date.toString()
//            chatDatasResult.accept(data)
            
        }.disposed(by: disposeBag)
        
//        input.viewDidAppearTrigger.withUnretained(self).flatMap { owner, _ in
//            NetworkManager.fetchChatMessage(roomId: owner.roomId, cursor: owner.latestDate)
//        }.subscribe { result in
//            switch result {
//                
//            }
//        }
        
        
        return Output(chatDatas: chatDatasResult.asDriver(onErrorJustReturn: List<ChatRealmModel>()))
    }
}
