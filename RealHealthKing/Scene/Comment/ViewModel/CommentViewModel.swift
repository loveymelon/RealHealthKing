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
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        var tempPostId = ""
        var tempCommentsData:[CommentsModel] = []
        
        let commentsResult = BehaviorRelay<[CommentsModel]>(value: [])
        let profileImageResult = BehaviorRelay(value: "")
        
        let commentsObservable = input.inputViewWillAppear.flatMapLatest { postId -> Observable<[CommentsModel]> in
            return Observable.create { observer in
                NetworkManager.fetchAccessPostDetails(postId: postId) { result in
                    switch result {
                    case .success(let data):
                        guard let datas = data.comments else { return observer.onNext([]) }
                        observer.onNext(datas)
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
                
                return Disposables.create()
            }
        }
        
        commentsObservable.subscribe(onNext: { comments in
            tempCommentsData = comments
            
            NetworkManager.fetchProfile { result in
                switch result {
                case .success(let data):
                    if let imageData = data.profileImage {
                        profileImageResult.accept(imageData)
                        commentsResult.accept(tempCommentsData)
                    } else {
                        profileImageResult.accept("person")
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }).disposed(by: disposeBag)
        
        input.inputButtonTap.subscribe { text in
            NetworkManager.createComments(commentModel: CommentModel(content: text), postId: tempPostId) { result in
                switch result {
                case .success(let data):
                    tempCommentsData.insert(data, at: 0)
                    commentsResult.accept(tempCommentsData)
                case .failure(let error):
                    print(error)
                }
            }
        }.disposed(by: disposeBag)
        
        return Output(outputCommentData: commentsResult.asDriver(), outputProfile: profileImageResult.asDriver())
    }
}
