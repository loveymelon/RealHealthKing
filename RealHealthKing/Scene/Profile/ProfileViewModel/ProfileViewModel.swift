//
//  ProfileViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/25/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class ProfileViewModel: ViewModelType {
    struct Input {
        let inputViewWillTrigger: Observable<Void>
        let inputLeftButtonTap: Observable<Void>
        let inputCollectionViewIndex: Observable<(cell: UICollectionViewCell, at: IndexPath)>
        let inputLogoutTap: Observable<Void>
        let inputWithrowTap: Observable<Void>
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
        let outputNodata: Driver<Bool>
        
        let outputLogout: Driver<Void>
        let outputWithdraw: Driver<Bool>
    }
    
    var viewState: ScreenState = .me
    
    var disposeBag = DisposeBag()
    var otherUserId = ""
    
    var isValid = false
    
    func transform(input: Input) -> Output {
        var cursor = ""
        
        let emailResult = BehaviorRelay(value: "")
        let nickResult = BehaviorRelay(value: "")
        let profileImage = BehaviorRelay(value: "")
        let followerCount = BehaviorRelay(value: 0)
        let followingCount = BehaviorRelay(value: 0)
        let postCount = BehaviorRelay(value: 0)
        let noDataResult = BehaviorRelay(value: false)
        
        let postDatasResult = BehaviorRelay<[Posts]>(value: [])
        
        let leftButtonResult = BehaviorRelay(value: "")
        let leftButtonTapResult = BehaviorRelay(value: false)
        
        let withdrawReslut = PublishRelay<Bool>()
        
        switch viewState {
        case .me:
            input.inputViewWillTrigger.flatMap {
                NetworkManager.fetchUserPosts()
            }.subscribe { result in
                NetworkManager.fetchProfile { profileResult in
                    switch profileResult {
                    case .success(let proFileData):
                        emailResult.accept(proFileData.email!)
                        nickResult.accept(proFileData.nick)
                        profileImage.accept(proFileData.profileImage ?? "")
                        followerCount.accept(proFileData.followers.count)
                        followingCount.accept(proFileData.following.count)
                        postCount.accept(proFileData.posts.count)
                        leftButtonResult.accept("프로필 편집")
                        
                        UserDefaults.standard.setValue(proFileData.nick, forKey: "nick")
                       
                        switch result {
                        case .success(let data):
                            cursor = data.nextCursor
                            postDatasResult.accept(data.data)
                        case .failure(let failure):
                            print(failure)
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                }
            } onError: { error in
                print(error)
            }.disposed(by: disposeBag)
            
            input.inputCollectionViewIndex.subscribe(with: self) { owner, item in
                
                if item.1.row == postDatasResult.value.count - 1 && cursor != "0" {
                    NetworkManager.fetchUserPosts(cursor: cursor)
                        .subscribe(onSuccess: { result in
                            switch result {
                            case .success(let data):
                                let temp = postDatasResult.value + data.data
                                
                                cursor = data.nextCursor
                                postDatasResult.accept(temp)
                            case .failure(let error):
                                // 에러가 발생했을 때 처리
                                print(error)
                            }
                        }, onFailure: { error in
                            // 에러가 발생했을 때 처리
                            print("!!!!!!!!!!!!",error)
                        })
                        .disposed(by: owner.disposeBag)
                }
            }.disposed(by: disposeBag)
            
            input.inputLeftButtonTap.subscribe { _ in
                leftButtonTapResult.accept(true)
            }.disposed(by: disposeBag)
            
            input.inputLogoutTap.subscribe(with: self) { owner, _ in
                
                KeyChainManager.shared.accessToken = ""
                KeyChainManager.shared.refreshToken = ""
                
            }.disposed(by: disposeBag)
            
            input.inputWithrowTap.flatMap { NetworkManager.withdraw() }.subscribe { result in
                
                switch result {
                
                case .success(_):
                    withdrawReslut.accept(true)
                case .failure(let error):
                    withdrawReslut.accept(false)
                }
                
            } onError: { error in
                print(error)
            }.disposed(by: disposeBag)
            
        case .other:
            
            input.inputViewWillTrigger.withUnretained(self).flatMap { owner, _ in
                return NetworkManager.otherUserPosts(userId: owner.otherUserId)
            }.subscribe(with: self) { owner, result in
                
                NetworkManager.otherUserProfile(userId: owner.otherUserId).subscribe { profileResult in
                    switch profileResult {
                        
                    case .success(let profileData):
                        
                        nickResult.accept(profileData.nick)
                        profileImage.accept(profileData.profileImage ?? "")
                        followerCount.accept(profileData.followers.count)
                        followingCount.accept(profileData.following.count)
                        postCount.accept(profileData.posts.count)
                        
                        if profileData.followers.isEmpty {
                            
                            leftButtonResult.accept("팔로우")
                            owner.isValid = false
                        } else {
                            
                            for follow in profileData.followers {
                                if follow.userId == KeyChainManager.shared.userId {
                                    leftButtonResult.accept("팔로잉")
                                    owner.isValid = true
                                    break
                                } else {
                                    leftButtonResult.accept("팔로우")
                                    owner.isValid = false
                                }
                            }
                            
                        }
                        
                        switch result {
                        case .success(let data):
                            cursor = data.nextCursor
                            postDatasResult.accept(data.data)
                        case .failure(let error):
                            print(error)
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                } onFailure: { error in
                    print(error)
                }.disposed(by: owner.disposeBag)

            } onError: { error,_  in
                print(error)
            }.disposed(by: disposeBag)
            
            input.inputCollectionViewIndex.subscribe(with: self) { owner, item in
                
                if item.1.row == postDatasResult.value.count - 1 && cursor != "0" {
                    NetworkManager.otherUserPosts(userId: owner.otherUserId, cursor: cursor)
                        .subscribe(onSuccess: { result in
                            switch result {
                            case .success(let data):
                                let temp = postDatasResult.value + data.data
                                
                                cursor = data.nextCursor
                                postDatasResult.accept(temp)
                            case .failure(let error):
                                print(error)
                            }
                        }, onFailure: { error in

                            print(error)
                        })
                        .disposed(by: owner.disposeBag)
                }
            }.disposed(by: disposeBag)

            input.inputLeftButtonTap.subscribe(with: self) { owner, _ in
                if owner.isValid {
                    NetworkManager.unFollow(userId: owner.otherUserId) { result in
                        switch result {
                        case .success(_):
                            leftButtonTapResult.accept(false)
                            leftButtonResult.accept("팔로우")
                            followerCount.accept(followerCount.value - 1)
                            owner.isValid.toggle()
                        case .failure(let error):
                            print(error)
                        }
                    }
                } else {
                    NetworkManager.createFollow(userId: owner.otherUserId) { result in
                        switch result {
                        case .success(_):
                            leftButtonTapResult.accept(false)
                            leftButtonResult.accept("팔로잉")
                            followerCount.accept(followerCount.value + 1)
                            owner.isValid.toggle()
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }.disposed(by: disposeBag)
            
        }
        
        return Output(profileEmail: emailResult.asDriver(), profileNick: nickResult.asDriver(), profileImage: profileImage.asDriver(), follwerCount: followerCount.asDriver(), follwingCount: followingCount.asDriver(), postDatas: postDatasResult.asDriver(), postCount: postCount.asDriver(), leftButton: leftButtonResult.asDriver(), outputLeftButtonTap: leftButtonTapResult.asDriver(), outputNodata: noDataResult.asDriver(), outputLogout: input.inputLogoutTap.asDriver(onErrorJustReturn: ()), outputWithdraw: withdrawReslut.asDriver(onErrorJustReturn: false))
    }
}
