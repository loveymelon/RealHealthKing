//
//  ProfileViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/25/24.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileViewModel: ViewModelType {
    struct Input {
        let inputViewWillTrigger: Observable<Void>
        let inputLeftButtonTap: Observable<Void>
    }
    
    struct Output {
        let profileEmail: Driver<String>
        let profileNick: Driver<String>
        let profileImage: Driver<String>
        let follwerCount: Driver<Int>
        let follwingCount: Driver<Int>
        let postDatas: Driver<[Posts]>
        let postCount: Driver<Int>
        
        let leftButton: Driver<String>
        let outputLeftButtonTap: Driver<Bool>
    }
    
    var viewState: ScreenState = .me
    
    var disposeBag = DisposeBag()
    
    var otherUserId = ""
    
    func transform(input: Input) -> Output {
        let emailResult = BehaviorRelay(value: "")
        let nickResult = BehaviorRelay(value: "")
        let profileImage = BehaviorRelay(value: "")
        let follwerCount = BehaviorRelay(value: 0)
        let follwingCount = BehaviorRelay(value: 0)
        let postCount = BehaviorRelay(value: 0)
        
        let postDatasResult = BehaviorRelay<[Posts]>(value: [])
        
        let leftButtonResult = BehaviorRelay(value: "")
        let leftButtonTapResult = BehaviorRelay(value: false)
        
        switch viewState {
        case .me:
            let postsObservable = input.inputViewWillTrigger.flatMapLatest { _ -> Observable<[Posts]> in
                return Observable.create { observer in
                    NetworkManager.fetchUserPosts { result in
                        switch result {
                        case .success(let data):
                            observer.onNext(data)
                            observer.onCompleted()
                        case .failure(let error):
                            observer.onError(error)
                        }
                    }
                    return Disposables.create()
                }
            }
            
            postsObservable.subscribe (onNext: { posts in
                NetworkManager.fetchProfile { result in
                    switch result {
                    case .success(let data):
                        emailResult.accept(data.email!)
                        nickResult.accept(data.nick)
                        profileImage.accept(data.profileImage ?? "")
                        follwerCount.accept(data.follwers?.count ?? 0)
                        follwingCount.accept(data.following?.count ?? 0)
                        postDatasResult.accept(posts)
                        postCount.accept(posts.count)
                        
                        leftButtonResult.accept("프로필 편집")
                        
                    case .failure(let error):
                        print(error)
                    }
                }
            }, onError: { error in
                print(error)
            }).disposed(by: disposeBag)
            
            input.inputLeftButtonTap.subscribe { _ in
                leftButtonTapResult.accept(true)
            }.disposed(by: disposeBag)
            
        case .other:
            let postsObservable = input.inputViewWillTrigger.flatMapLatest { _ -> Observable<[Posts]> in
                return Observable.create { [weak self] observer in
                    guard let self else { return Disposables.create() }
                    NetworkManager.otherUserPosts(userId: otherUserId) { result in
                        switch result {
                        case .success(let data):
                            observer.onNext(data)
                            observer.onCompleted()
                        case .failure(let error):
                            observer.onError(error)
                        }
                    }
                    return Disposables.create()
                }
            }
            
            postsObservable.subscribe(with: self) { owner, posts in
                NetworkManager.otherUserProfile(userId: owner.otherUserId) { result in
                    switch result {
                    case .success(let data):
                        
                        nickResult.accept(data.nick)
                        profileImage.accept(data.profileImage ?? "")
                        follwerCount.accept(data.follwers?.count ?? 0)
                        follwingCount.accept(data.following?.count ?? 0)
                        postDatasResult.accept(posts)
                        postCount.accept(posts.count)
                        
                        if let following = data.following {
                            
                            if following.isEmpty {
                                leftButtonResult.accept("팔로우")
                            }
                            
                            for follow in following {
                                if follow.userId == KeyChainManager.shared.userId {
                                    leftButtonResult.accept("맞팔로잉")
                                    break
                                } else {
                                    leftButtonResult.accept("팔로우")
                                }
                            }
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                }
            } onError: { owner, error in
                print(error)
            }.disposed(by: disposeBag)

            input.inputLeftButtonTap.subscribe(with: self) { owner, _ in
                print("들어오냐?")
                NetworkManager.createFollow(userId: owner.otherUserId) { result in
                    switch result {
                    case .success(let data):
                        print(data)
                        leftButtonTapResult.accept(false)
                        leftButtonResult.accept("팔로잉")
                    case .failure(let error):
                        print(error)
                    }
                }
            }.disposed(by: disposeBag)
            
        }
        
        return Output(profileEmail: emailResult.asDriver(), profileNick: nickResult.asDriver(), profileImage: profileImage.asDriver(), follwerCount: follwerCount.asDriver(), follwingCount: follwingCount.asDriver(), postDatas: postDatasResult.asDriver(), postCount: postCount.asDriver(), leftButton: leftButtonResult.asDriver(), outputLeftButtonTap: leftButtonTapResult.asDriver())
    }
}
