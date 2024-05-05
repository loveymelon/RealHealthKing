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
        let inputViewWillTirgger: Observable<Void>
        let inputTableViewIndex: Observable<WillDisplayCellEvent>
    }
    
    struct Output {
        let postsDatas: Driver<[Posts]>
        let outputNoData: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    
    func transform(input: Input) -> Output {
        
        let resultPostsDatas = BehaviorRelay<[Posts]>(value: [])
        let noDataResult = BehaviorRelay(value: false)
        var cursor = ""
        
        input.inputViewWillTirgger.flatMap { NetworkManager.fetchPosts(productId: "myLoveGym") }.subscribe { result in
            switch result {
                
            case .success(let data):
                noDataResult.accept(data.data.isEmpty)
                cursor = data.nextCursor
                resultPostsDatas.accept(data.data)
            case .failure(let error):
                print(error)
            }
            
        } onError: { error in
            print(error)
        }.disposed(by: disposeBag)
        
        input.inputTableViewIndex.subscribe(with: self) { owner, index in
            if index.indexPath.row == resultPostsDatas.value.count - 1 && cursor != "0" {
                NetworkManager.pagePosts(cursor: cursor) { result in
                    print("net")
                    switch result {
                    case .success(let data):
                        cursor = data.nextCursor
                        let temp = resultPostsDatas.value + data.data
                        print("afdaf")
                        resultPostsDatas.accept(temp)
                        
                        if cursor == "0" {
                            owner.disposeBag = DisposeBag()
                        }
                    case .failure(let error):
                        print("dsafasfads")
                        print(error.description)
                    }
                }
            }
        }.disposed(by: disposeBag)
        
        return Output(postsDatas: resultPostsDatas.asDriver(), outputNoData: noDataResult.asDriver())
    }
}
