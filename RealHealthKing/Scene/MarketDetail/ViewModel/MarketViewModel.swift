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
    }
    
    struct Output {
        let outputPostData: Driver<Posts>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let postDataResult = PublishRelay<Posts>()
        
        input.inputPostId.withUnretained(self).flatMap { owner, postId in
            return NetworkManager.fetchAccessPostDetails(postId: postId)
        }.subscribe { detailResult in
            
            switch detailResult {
            case .success(let data):
                postDataResult.accept(data)
                
                
            case .failure(let error):
                print(error)
            }
            
        } onError: { error in
            print(error)
        }.disposed(by: disposeBag)
        
        return Output(outputPostData: postDataResult.asDriver(onErrorJustReturn: Posts()))
    }
}
