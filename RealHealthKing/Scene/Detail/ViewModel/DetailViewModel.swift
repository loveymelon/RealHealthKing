//
//  DetailViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/29/24.
//

import Foundation
import RxSwift
import RxCocoa

class DetailViewModel: ViewModelType {
    struct Input {
        let inputPostId: Observable<String>
    }
    
    struct Output {
        let outputPostData: Driver<Posts>
        let outputLikeValue: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let postDataResult = BehaviorRelay(value: Posts())
        let resultLikeValue = BehaviorRelay(value: false)
        
        input.inputPostId.subscribe { id in
            
            NetworkManager.fetchAccessPostDetails(postId: id) { result in
                switch result {
                case .success(let data):
                    
                    postDataResult.accept(data)
                    
                    let state = data.likes.contains(KeyChainManager.shared.userId)
                    
                    resultLikeValue.accept(state)
                case .failure(let error):
                    print(error)
                }
            }
        }.disposed(by: disposeBag)
        
        return Output(outputPostData: postDataResult.asDriver(), outputLikeValue: resultLikeValue.asDriver())
    }
}
