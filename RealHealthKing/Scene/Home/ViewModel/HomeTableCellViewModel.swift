//
//  HomeTableCellViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/23/24.
//

import Foundation
import RxSwift
import RxCocoa

class HomeTableCellViewModel: ViewModelType {
    struct Input {
        let inputLikeButtonTap: Observable<Posts>
        let inputLikeValue: Observable<[String]>
    }
    
    struct Output {
        let outputLikeValue: Observable<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    deinit {
        print(#function)
    }
    
    func transform(input: Input) -> Output {
        
        let resultLikeValue = BehaviorRelay(value: false)
        
        input.inputLikeValue.subscribe { likes in
            print("start", likes.contains(KeyChainManager.shared.userId))
            resultLikeValue.accept(likes.contains(KeyChainManager.shared.userId))
        }.disposed(by: disposeBag)
        
        input.inputLikeButtonTap.subscribe { value in
            
            guard let postData = value.element else { return }

            let likeState = postData.likes.contains(KeyChainManager.shared.userId)
            
            NetworkManager.postLike(postId: postData.postId ?? "empty", likeQuery: LikeQuery(likeStatus: !likeState)) { result in
                switch result {
                case .success(let data):
                    NotificationCenterManager.like.post()
                    print("tap", data.likeStatus)
                case .failure(let error):
                    print(error)
                }
            }
            
        }.disposed(by: disposeBag)
        
        return Output(outputLikeValue: resultLikeValue.asObservable())
    }
}
