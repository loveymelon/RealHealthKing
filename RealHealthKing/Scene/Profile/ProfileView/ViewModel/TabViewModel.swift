//
//  TabViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/11/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class TabViewModel: ViewModelType {
    struct Input {
        let inputViewWillTrigger: Observable<Void>
        let inputCollectionViewIndex: Observable<(cell: UICollectionViewCell, at: IndexPath)>
    }
    
    struct Output {
        let outputPostDatas: Driver<[Posts]>
    }
    
    var viewState: ScreenState = .me
    var userId = ""
    var productId = ""
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        var cursor = ""
        
        let postDatasResult = BehaviorRelay<[Posts]>(value: [])
        
        switch viewState {
        case .me:
            
            input.inputViewWillTrigger.withUnretained(self).flatMap { owner, _ in
                return NetworkManager.fetchUserPosts(productId: owner.productId)
            }.subscribe { result in
                
                switch result {
        
                case .success(let data):
                    cursor = data.nextCursor
                    postDatasResult.accept(data.data)
                case .failure(let error):
                    print(error)
                }
                
            } onError: { error in
                print(error)
            }.disposed(by: disposeBag)
            
            
            input.inputCollectionViewIndex.subscribe(with: self) { owner, item in
                
                if item.1.row == postDatasResult.value.count - 1 && cursor != "0" {
                    NetworkManager.fetchUserPosts(cursor: cursor, productId: owner.productId)
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
                            print("!!!!!!!!!!!!", error)
                        })
                        .disposed(by: owner.disposeBag)
                }
                
            }.disposed(by: disposeBag)
            
        case .other:
            
            input.inputViewWillTrigger.withUnretained(self).flatMap { owner, _ in
                NetworkManager.otherUserPosts(userId: owner.userId, productId: owner.productId)
            }.subscribe { result in
                
                switch result {
        
                case .success(let data):
                    cursor = data.nextCursor
                    postDatasResult.accept(data.data)
                case .failure(let error):
                    print(error)
                }
                
            }.disposed(by: disposeBag)
            
            
            input.inputCollectionViewIndex.subscribe(with: self) { owner, item in
                
                if item.1.row == postDatasResult.value.count - 1 && cursor != "0" {
                    NetworkManager.otherUserPosts(userId: owner.userId, cursor: cursor, productId: owner.productId)
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
                            print("!!!!!!!!!!!!", error)
                        })
                        .disposed(by: owner.disposeBag)
                }
                
            }.disposed(by: disposeBag)
        }
        
        
        

        
        return Output(outputPostDatas: postDatasResult.asDriver(onErrorJustReturn: []))
    }
}
