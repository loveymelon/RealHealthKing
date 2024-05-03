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
    }
    
    struct Output {
        let outputPostData: Driver<Posts>
        let outputLikeValue: Driver<Bool>
        let outputVC: Driver<UIViewController>
    }
    
    
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        var userId = ""
        
        let postDataResult = BehaviorRelay(value: Posts())
        let resultLikeValue = BehaviorRelay(value: false)
        
        let resultVC = PublishRelay<UIViewController>()
        
        input.inputPostId.withUnretained(self).subscribe { owner, id in
            
            NetworkManager.fetchAccessPostDetails(postId: id) { result in
                switch result {
                case .success(let data):
                    
                    postDataResult.accept(data)
                    userId = data.creator.userId
                    
                    let state = data.likes.contains(KeyChainManager.shared.userId)
                    
                    resultLikeValue.accept(state)
                case .failure(let error):
                    print(error)
                }
            }
        }.disposed(by: disposeBag)
        
        input.inputProfileImageTap.subscribe { _ in
            let vc = ProfileViewController()
            
            if KeyChainManager.shared.userId == userId {
                vc.viewModel.viewState = .me
            } else {
                vc.viewModel.otherUserId = userId
                vc.viewModel.viewState = .other
            }
            
            resultVC.accept(vc)
            
        }.disposed(by: disposeBag)
        
        return Output(outputPostData: postDataResult.asDriver(), outputLikeValue: resultLikeValue.asDriver(), outputVC: resultVC.asDriver(onErrorJustReturn: UIViewController()))
    }
}
