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
        let inputButtonTap: Observable<String>
    }
    
    struct Output {
        let outputCommentData: Driver<[CommentsModel]>
        let outputProfile: Driver<String>
        let outputNoData: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        var tempCommentsData:[CommentsModel] = []
        let noDataResult = BehaviorRelay(value: false)
        
        let commentsResult = PublishRelay<[CommentsModel]>()
        let profileImageResult = BehaviorRelay(value: "")
        
        input.inputViewWillAppear.flatMap { postId in
            return NetworkManager.fetchAccessPostDetails(postId: postId)
        }.subscribe { detailResult in
            
            NetworkManager.fetchProfile { profileResult in
                
                switch profileResult {
                    
                case .success(let data):
                    if let imageData = data.profileImage {
                        
                        profileImageResult.accept(imageData)
                         
                    } else {
                        
                        profileImageResult.accept("person")
                        
                    }
                    
                    switch detailResult {
                        
                    case .success(let detailData):
                        
                        tempCommentsData = detailData.comments
                        commentsResult.accept(tempCommentsData)
                        noDataResult.accept(!tempCommentsData.isEmpty) 
                        
                    case .failure(let error):
                        print("error", error)
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        } onError: { error in
            print(error)
        }.disposed(by: disposeBag)
        
        input.inputButtonTap.subscribe { text in
            print("comment", CommentsModel(content: text))
            NetworkManager.createComments(commentModel: CommentsModel(content: text)) { result in
                switch result {
                case .success(let data):
                    tempCommentsData.insert(data, at: 0)
                    commentsResult.accept(tempCommentsData)
                    print(data)
                case .failure(let error):
                    print(error)
                }
            }
        }.disposed(by: disposeBag)
        
        return Output(outputCommentData: commentsResult.asDriver(onErrorJustReturn: []), outputProfile: profileImageResult.asDriver(), outputNoData: noDataResult.asDriver())
    }
}
