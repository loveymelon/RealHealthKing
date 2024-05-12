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
        var tempPostId = ""
        var tempCommentsData:[CommentsModel] = []
        var noDataResult = BehaviorRelay(value: false)
        
        let commentsResult = PublishRelay<[CommentsModel]>()
        let profileImageResult = BehaviorRelay(value: "")
        
        input.inputViewWillAppear.flatMap { postId in
            return NetworkManager.fetchAccessPostDetails(postId: postId)
        }.subscribe { detailResult in
            
            NetworkManager.fetchProfile { profileResult in
                
                switch profileResult {
                    
                case .success(let data):
                    if let imageData = data.profileImage {
                        
                        if let imageData = data.profileImage {
                            profileImageResult.accept(imageData)
                        } else {
                            profileImageResult.accept("person")
                        }
                        
                        switch detailResult {
                            
                        case .success(let detailData):
                            print("detail")
                            tempCommentsData = detailData.comments
                            print(detailData)
                            profileImageResult.accept(imageData)
                            commentsResult.accept(tempCommentsData)
                        case .failure(let error):
                            print("error", error)
                        }
                        
                    } else {
                        profileImageResult.accept("person")
                        
                        switch detailResult {
                            
                        case .success(let detailData):
                            print("detail")
                            tempCommentsData = detailData.comments
                            print(detailData)
                            commentsResult.accept(tempCommentsData)
                        case .failure(let error):
                            print("error", error)
                        }
                        
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } onError: { error in
            print(error)
        }.disposed(by: disposeBag)

        
//        let commentsObservable = input.inputViewWillAppear.flatMapLatest { postId -> Observable<[CommentsModel]> in
//            return Observable.create { observer in
//                NetworkManager.fetchAccessPostDetails(postId: postId) { result in
//                    switch result {
//                    case .success(let data):
//                        print("data", data.comments)
//                        profileImageResult.accept(imageData)
//                        commentsResult.accept(tempCommentsData)
//                    case .failure(let error):
//                        observer.onError(error)
//                    }
//                }
//                
//                return Disposables.create()
//            }
//        }
        
//        commentsObservable.subscribe(onNext: { comments in
//            
//            NetworkManager.fetchProfile { result in
//                switch result {
//                case .success(let data):
//                    if let imageData = data.profileImage {
//                        print("comment", tempCommentsData)
//                        profileImageResult.accept(imageData)
//                        commentsResult.accept(tempCommentsData)
//                        
//                    } else {
//                        profileImageResult.accept("person")
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//            }
//        }).disposed(by: disposeBag)
        
        input.inputButtonTap.subscribe { text in
            print("comment", CommentsModel(content: text))
            NetworkManager.createComments(commentModel: CommentsModel(content: text), postId: tempPostId) { result in
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
