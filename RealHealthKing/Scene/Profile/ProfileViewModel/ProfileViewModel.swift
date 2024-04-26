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
    }
    
    struct Output {
        let profileEmail: Driver<String>
        let profileNick: Driver<String>
        let profileImage: Driver<String>
        let follwerCount: Driver<Int>
        let follwingCount: Driver<Int>
        let postDatas: Driver<[Posts]>
    }
    
    var disposeBag = DisposeBag()
    
    
    func transform(input: Input) -> Output {
        let emailResult = BehaviorRelay(value: "")
        let nickResult = BehaviorRelay(value: "")
        let profileImage = BehaviorRelay(value: "")
        let follwerCount = BehaviorRelay(value: 0)
        let follwingCount = BehaviorRelay(value: 0)
        
        let postDatasResult = BehaviorRelay<[Posts]>(value: [])
        
        input.inputViewWillTrigger.subscribe { _ in
            
            NetworkManager.fetchProfile { result in
                switch result {
                case .success(let data):
                    
                    emailResult.accept(data.email)
                    nickResult.accept(data.nick)
                    profileImage.accept(data.profileImage ?? "")
                    follwerCount.accept(data.follwers?.count ?? 0)
                    follwingCount.accept(data.following?.count ?? 0)
                    
                    
                case .failure(let error):
                    print(error)
                }
            }
            
            NetworkManager.fetchUserPosts { result in
                switch result {
                case .success(let data):
                    postDatasResult.accept(data)
                case .failure(let error):
                    print(error)
                }
            }
            
        }.disposed(by: disposeBag)
        
        return Output(profileEmail: emailResult.asDriver(), profileNick: nickResult.asDriver(), profileImage: profileImage.asDriver(), follwerCount: follwerCount.asDriver(), follwingCount: follwingCount.asDriver(), postDatas: postDatasResult.asDriver())
    }
}
