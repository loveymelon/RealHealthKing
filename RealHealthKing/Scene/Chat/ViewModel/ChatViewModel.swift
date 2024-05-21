//
//  ChatViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/17/24.
//

import Foundation
import RxSwift
import RxCocoa

class ChatViewModel: ViewModelType {
    struct Input {
        let viewWillAppearTrigger: Observable<String>
    }
    
    struct Output {
        
    }
    
    private let realmRepository = RealmRepository()
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        input.viewWillAppearTrigger.withUnretained(self).flatMap { owner, roomId in
            
            if let model = owner.realmRepository.fetchItem(roomId: roomId).last {
                return NetworkManager.fetchChatMessage(roomId: roomId, cursor: model.date.toString())
            } else {
                return NetworkManager.fetchChatMessage(roomId: roomId, cursor: Date().toString())
            }
            
        }.subscribe(with: self) { owner, result in
            
            switch result {
            case .success(let data):
                print(data.data.count)
            case .failure(let error):
                print(error)
            }
            
        }.disposed(by: disposeBag)
        
        return Output()
    }
}
