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
//        let viewWillAppearTrigger: Observable<ChatModel>
    }
    
    struct Output {
        
    }
    
    private let realmRepository = RealmRepository()
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
//        input.viewWillAppearTrigger.withUnretained(self).flatMap { owner, model in
//            
//            let datas = owner.realmRepository.fetchItem()
//            
//            if datas.isEmpty {
//                
//            } else {
//                
//            }
//            
//            return NetworkManager.fetchChatMessage(roomId: model.roomId, cursor: Date().toString())
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
        
        return Output()
    }
}
