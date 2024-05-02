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
        let inputLikeButtonTap: Observable<(Bool, Posts)>
        let inputLikeValue: Observable<[String]>
    }
    
    struct Output {
        let outputFirstLikeValue: Driver<Bool>
        let outputTapLikeValue: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    deinit {
        print(#function)
    }
    
    func transform(input: Input) -> Output {
        
        let resultFirstLikeValue = BehaviorRelay(value: false)
        let resultTapLikeValue = PublishSubject<Bool>()
        
        input.inputLikeValue.subscribe { likes in
            
            if !likes.isEmpty {
                
                if likes[0] == "true" {
                    resultFirstLikeValue.accept(true)
                } else if likes[0] == "false" {
                    resultFirstLikeValue.accept(false)
                } else {
                    resultFirstLikeValue.accept(likes.contains(KeyChainManager.shared.userId))
                }
                
            } else {
                resultFirstLikeValue.accept(likes.contains(KeyChainManager.shared.userId))
            }
            
        }.disposed(by: disposeBag)
        
        input.inputLikeButtonTap.subscribe { value in

            // 기존 데이터를 계속 보고 있어서 한 번만 반영이 되는 것이다.
            NetworkManager.postLike(postId: value.1.postId ?? "empty", likeQuery: LikeQuery(likeStatus: value.0)) { result in
                switch result {
                case .success(let data):
                    
                    print("tap", data.likeStatus)
                    resultTapLikeValue.onNext(data.likeStatus)
                    
                case .failure(let error):
                    print(error)
                }
            }
            
        }.disposed(by: disposeBag)
        
        return Output(outputFirstLikeValue: resultFirstLikeValue.asDriver(), outputTapLikeValue: resultTapLikeValue.asDriver(onErrorJustReturn: false))
    }
}
