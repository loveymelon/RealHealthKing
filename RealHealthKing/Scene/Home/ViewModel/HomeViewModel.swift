//
//  HomeViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/22/24.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel: ViewModelType {
    
    struct Input {
        let notificationEvent: Observable<Void>
        let inputTableViewIndex: Observable<WillDisplayCellEvent>
    }
    
    struct Output {
        let postsDatas: Driver<[Posts]>
    }
    
    var disposeBag = DisposeBag()
    
    
    func transform(input: Input) -> Output {
        
        let resultPostsDatas = BehaviorRelay<[Posts]>(value: [])
        var cursor = ""
        
        input.notificationEvent.subscribe (with: self) { owner, _ in
            NetworkManager.fetchPosts { result in
                print("networking")
                switch result {
                case .success(let data):
                    cursor = data.nextCursor
                    resultPostsDatas.accept(data.data)
                case .failure(let error):
                    print(error.description)
                }
            }
        }.disposed(by: disposeBag)
        
        input.inputTableViewIndex.subscribe(with: self) { owner, index in
            if index.indexPath.row == resultPostsDatas.value.count - 1 && cursor != "0" {
                NetworkManager.pagePosts(cursor: cursor) { result in
                    print("net")
                    switch result {
                    case .success(let data):
                        cursor = data.nextCursor
                        let temp = resultPostsDatas.value + data.data
                        
                        resultPostsDatas.accept(temp)
                        
                        if cursor == "0" {
                            owner.disposeBag = DisposeBag()
                        }
                    case .failure(let error):
                        print(error.description)
                    }
                }
            }
        }.disposed(by: disposeBag)
        
        return Output(postsDatas: resultPostsDatas.asDriver())
    }
}
