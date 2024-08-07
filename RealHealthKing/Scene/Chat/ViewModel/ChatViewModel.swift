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

final class ChatViewModel: ViewModelType {
    struct Input {
        let viewWillAppearTrigger: Observable<Void>
        let viewDidAppearTrigger: Observable<Void>
        let viewDidDisappearTrigger: Observable<Void>
        let sendButtonTap: Observable<String>
    }
    
    struct Output {
        let chatDatas: Driver<[ChatRealmModel]>
        let chatCount: Driver<Int>
    }
    
    private let realmRepository = RealmRepository()
    
    private let isValidData = PublishRelay<Bool>()
    
    var roomId = ""
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let chatDatasResult = PublishRelay<[ChatRealmModel]>()
        let countResult = PublishRelay<Int>()
        
        input.viewWillAppearTrigger.subscribe(with: self) { owner, _ in
            
            let data = owner.realmRepository.fetchItem(roomId: owner.roomId)
            
            if data == nil {
                do {
                    
                    try owner.realmRepository.createChatRoom(roomId: owner.roomId)
                    owner.isValidData.accept(false)
                    
                } catch {
                    
                    print(error)
                    
                }
                
                return
            }
//            guard let data else {
//                do {
//                    
//                    try owner.realmRepository.createChatRoom(roomId: owner.roomId)
//                    owner.isValidData.accept(false)
//                    
//                } catch {
//                    
//                    print(error)
//                    
//                }
//                
//                return
//                
//            }
            
            owner.isValidData.accept(true)
            
        }.disposed(by: disposeBag)
        
        input.sendButtonTap.withUnretained(self).flatMap { owner, text in
            
            NetworkManager.chatPost(chatRoomId: owner.roomId, chatPostModel: ChatPostModel(content: text, files: []))
            
        }.subscribe(with: self, onNext: { owner, result in
            
            switch result {
                
            case .success(_):
                
                print("success")
                
            case .failure(let error):
                print(error)
                
            }
            
        }, onError: { owner, error in
            print(error)
        }).disposed(by: disposeBag)
        
        input.viewDidDisappearTrigger.subscribe(with: self) { owner, _ in
            owner.realmRepository.stopNotification()
            SocketIOManager.shared.leaveConnection()
        }.disposed(by: disposeBag)
        
        isValidData.withUnretained(self).flatMap { owner, isValid in
            
            let date = owner.realmRepository.fetchItem(roomId: owner.roomId)?.chatmodel.last?.date
            
            if isValid {
                return NetworkManager.fetchChatMessage(roomId: owner.roomId, cursor: date?.toString() ?? Date().toString())
            } else {
                return NetworkManager.fetchChatMessage(roomId: owner.roomId, cursor: "")
            }

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
                
                owner.socketStart()
                
            case .failure(let error):
                print(error)
            }
            
        } onError: { error in
            print(error)
        }.disposed(by: disposeBag)
        
        realmRepository.startNotification(roomId: roomId) { [weak self] result in
            
            guard let self else { return }
            
            switch result {
            case .success(let data):
                
                chatDatasResult.accept(data)
                countResult.accept(data.count)
                
            case .failure(let error):
                print(error)
            }
        }
        
        return Output(chatDatas: chatDatasResult.asDriver(onErrorJustReturn: []), chatCount: countResult.asDriver(onErrorJustReturn: 0))
    }

}

extension ChatViewModel {
    private func socketStart() {
        SocketIOManager.shared.startNetwork(roomId: roomId) { [weak self] model in
            
            guard let self else { return }
            
            let isValid = model.sender.userId == KeyChainManager.shared.userId
            
            do {
                
                try realmRepository.createChatItems(roomId: roomId, chatModel: model, isUser: isValid)
                
            } catch {
                
                print(error)
                
            }

        }
        
        SocketIOManager.shared.establishConnection()
    }
}
