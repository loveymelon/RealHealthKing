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
    
    private let isValidData = PublishRelay<Bool>()
    
    var roomId = ""
    private var latestDate = ""
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
        
        input.viewWillAppearTrigger.subscribe(with: self) { owner, _ in
            
            let data = owner.realmRepository.fetchItem(roomId: owner.roomId)
            
            owner.checkMessageData(data: data)
            
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
    
    func checkMessageData(data: Results<ChatRoomRealmModel>) {
        
        if data.isEmpty {
            
            isValidData.withUnretained(self).flatMap { owner, _ in
                NetworkManager.fetchChatMessage(roomId: owner.roomId, cursor: "")
            }.withUnretained(self).subscribe { owner, result in
                
                switch result {
                    
                case .success(let data):
                    
                    for chat in data.data {
                        
                        let isValid = chat.sender.userId == KeyChainManager.shared.userId
                        
                        do {
                            
                            try owner.realmRepository.createChatItems(roomId: owner.roomId, chatModel: chat, isUser: isValid)
                            
                        } catch {
                            
                            print(error)
                            
                        }
                        
                    }
                    
                    SocketIOManager.shared.startNetwork(roomId: owner.roomId) { model in
                        
                        let isValid = model.sender.userId == KeyChainManager.shared.userId
                        
                        do {
                            
                            try owner.realmRepository.createChatItems(roomId: owner.roomId, chatModel: model, isUser: isValid)
                            
                        } catch {
                            
                            print(error)
                            
                        }

                    }
                    
                case .failure(let error):
                    print(error)
                }
                
            } onError: { error in
                print(error)
            }.disposed(by: disposeBag)
            
        }
        
    }
}
