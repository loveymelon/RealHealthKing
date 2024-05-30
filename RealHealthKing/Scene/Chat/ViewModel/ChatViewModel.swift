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
        let sendButtonTap: Observable<String>
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
        
        input.viewWillAppearTrigger.subscribe(with: self) { owner, _ in
            let data = owner.realmRepository.fetchItem(roomId: owner.roomId)[0]
            
            if data.chatmodel.isEmpty {
                
                print("abcdefg")
                owner.isValidData.accept(data.chatmodel.isEmpty)
//                owner.checkMessageData(data: data)`
                
            } else {
                
                chatDatasResult.accept(data.chatmodel)
            }
            
        }.disposed(by: disposeBag)
        
        input.viewDidAppearTrigger.subscribe(with: self) { owner, _ in
            owner.realmRepository.startNotification(roomId: owner.roomId) { result in
                switch result {
                case .success(_):
                    let data = owner.realmRepository.fetchItem(roomId: owner.roomId)
                    
                    chatDatasResult.accept(data[0].chatmodel)
                case .failure(let error):
                    print(error)
                }
            }
        }.disposed(by: disposeBag)
        
        input.sendButtonTap.subscribe { text in
            print(text)
        }.disposed(by: disposeBag)
        
        isValidData.withUnretained(self).flatMap { owner, _ in
            NetworkManager.fetchChatMessage(roomId: owner.roomId, cursor: "")
        }.withUnretained(self).subscribe { owner, result in
            
            print("fuck fucking coding fuck fuck fuck Is Here?")
            
            switch result {
                
            case .success(let data):
                
                print(owner.roomId, data.data)
                
                for chat in data.data {
                    
                    let isValid = chat.sender.userId == KeyChainManager.shared.userId
                    
                    do {
                        
                        try owner.realmRepository.createChatItems(roomId: owner.roomId, chatModel: chat, isUser: isValid)
                        
                    } catch {
                        
                        print(error)
                        
                    }
                    
                }
                
//                SocketIOManager.shared.startNetwork(roomId: owner.roomId) { model in
//                    
//                    let isValid = model.sender.userId == KeyChainManager.shared.userId
//                    
//                    do {
//                        
//                        try owner.realmRepository.createChatItems(roomId: owner.roomId, chatModel: model, isUser: isValid)
//                        
//                    } catch {
//                        
//                        print(error)
//                        
//                    }
//
//                }
                
            case .failure(let error):
                print(error)
            }
            
        } onError: { error in
            print(error)
        }.disposed(by: disposeBag)
        
        
        return Output(chatDatas: chatDatasResult.asDriver(onErrorJustReturn: List<ChatRealmModel>()))
    }

}
