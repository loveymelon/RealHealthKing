//
//  DetailViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/29/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

final class DetailViewModel: ViewModelType {
    struct Input {
        let inputPostId: Observable<String>
        let inputProfileImageTap: Observable<ControlEvent<UITapGestureRecognizer>.Element>
        let likeButtonTap: Observable<(buttonState: Bool, postId: String)>
    }
    
    struct Output {
        let outputPostData: Driver<Posts>
        let outputLikeValue: Driver<Bool>
        let outputVC: Driver<(enumValue: ScreenState, userId: String)>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        var userId = ""
        
        let postDataResult = BehaviorRelay(value: Posts())
        let resultLikeValue = BehaviorRelay(value: false)
        
        let resultVC = PublishRelay<(enumValue:ScreenState, userId:String)>()
        
        input.inputPostId.withUnretained(self).flatMap { owner, postId in
            return NetworkManager.fetchAccessPostDetails(postId: postId)
        }.subscribe { detailResult in
            
            switch detailResult {
            case .success(let data):
                postDataResult.accept(data)
                userId = data.creator.userId
                
                let state = data.likes.contains(KeyChainManager.shared.userId)
                
                resultLikeValue.accept(state)
            case .failure(let error):
                print(error)
            }
            
        } onError: { error in
            print(error)
        }.disposed(by: disposeBag)
        
        input.inputProfileImageTap.subscribe { _ in
            let screenState = ScreenState.other
            
            if KeyChainManager.shared.userId == userId {
                resultVC.accept((enumValue: .me, userId: KeyChainManager.shared.userId))
            } else {
                resultVC.accept((enumValue: .other, userId: userId))
            }
            
        }.disposed(by: disposeBag)
        
        input.likeButtonTap.subscribe { value in
            NetworkManager.postLike(postId: value.postId, likeQuery: LikeQuery(likeStatus: value.buttonState)) { result in
                switch result {
                case .success(let data):
                    resultLikeValue.accept(data.likeStatus)
                case .failure(let error):
                    print(error)
                }
            }
        }.disposed(by: disposeBag)
        
        return Output(outputPostData: postDataResult.asDriver(), outputLikeValue: resultLikeValue.asDriver(), outputVC: resultVC.asDriver(onErrorJustReturn: (enumValue: .other, userId: "empty")))
    }
}
