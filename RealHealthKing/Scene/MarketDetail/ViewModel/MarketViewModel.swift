//
//  MarketViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/15/24.
//

import Foundation
import RxSwift
import RxCocoa

class MarketViewModel: ViewModelType {
    struct Input {
        let inputPostId: Observable<String>
        let messageButtonTap: Observable<Void>
    }
    
    struct Output {
        let outputPostData: Driver<Posts>
        let outputRoomId: Driver<ChatRoomModel>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let postDataResult = PublishRelay<Posts>()
        let roomIdResult = PublishRelay<ChatRoomModel>()
        var userId = ""
        
        input.inputPostId.withUnretained(self).flatMap { owner, postId in
            return NetworkManager.fetchAccessPostDetails(postId: postId)
        }.subscribe { detailResult in
            
            switch detailResult {
            case .success(let data):
                postDataResult.accept(data)
                userId = data.creator.userId
            case .failure(let error):
                print(error)
            }
            
        } onError: { error in
            print(error)
        }.disposed(by: disposeBag)
        
        input.messageButtonTap.flatMap {
            NetworkManager.connectChat(userId: userId)
        }.subscribe { result in
            switch result {
                
            case .success(let data):
                print(data.lastChat, data.roomId)
                roomIdResult.accept(data)
            case .failure(let error):
                print(error)
            }
            
        } onError: { error in
            print(error)
        }.disposed(by: disposeBag)
        
        return Output(outputPostData: postDataResult.asDriver(onErrorJustReturn: Posts()), outputRoomId: roomIdResult.asDriver(onErrorJustReturn: ChatRoomModel()))
    }
}
