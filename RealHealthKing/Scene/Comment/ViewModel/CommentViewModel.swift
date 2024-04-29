//
//  CommentViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/29/24.
//

import Foundation
import RxSwift
import RxCocoa

class CommentViewModel: ViewModelType {
    struct Input {
        let inputViewWillAppear: Observable<String>
    }
    
    struct Output {
        let outputCommentData: Driver<[CommentsModel]>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let commentsResult = BehaviorRelay<[CommentsModel]>(value: [])
        
        input.inputViewWillAppear.subscribe { postId in
            NetworkManager.fetchAccessPostDetails(postId: postId) { result in
                switch result {
                case .success(let data):
                    print(data)
                    commentsResult.accept(data.comments ?? [])
                    print(data)
                case .failure(let error):
                    print(error)
                }
            }
        }.disposed(by: disposeBag)
        
        return Output(outputCommentData: commentsResult.asDriver())
    }
}
