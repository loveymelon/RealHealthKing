//
//  ChatListViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/20/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ChatListViewModel: ViewModelType {
    
    struct Input {
        let viewWillAppearTrigger: Observable<Void>
    }
    
    struct Output {
        let chatListData: Driver<[ChatRoomModel]>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let chatListResult = PublishRelay<[ChatRoomModel]>()
        
        input.viewWillAppearTrigger.flatMap {
            NetworkManager.fetchChatRoom()
        }.subscribe { result in
            switch result {
        
            case .success(let data):
                print(data.data.count)
                chatListResult.accept(data.data)
            case .failure(let error):
                print(error)
            }
            
        } onError: { error in
            print(error)
        }.disposed(by: disposeBag)
 
        return Output(chatListData: chatListResult.asDriver(onErrorJustReturn: []))
    }
}
