//
//  ShopViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/4/24.
//

import Foundation
import RxSwift
import RxCocoa

class ShopViewModel: ViewModelType {
    struct Input {
        let viewWillAppearTrigger: Observable<Void>
    }
    
    struct Output {
        let shopDatas: Driver<[Posts]>
        let noDataIsValid: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let shopResult = PublishRelay<[Posts]>()
        let noDataResult = PublishRelay<Bool>()
        
        input.viewWillAppearTrigger
            .flatMap { NetworkManager.fetchPosts(productId: "healthProduct") }.subscribe { result in
                switch result {

                case .success(let data):
//                    print(data)
                    shopResult.accept(data.data)
                    noDataResult.accept(!data.data.isEmpty)
                case .failure(let error):
                    print(error)
                }
                
            } onError: { error in
                print(error)
            }.disposed(by: disposeBag)
        
        return Output(shopDatas: shopResult.asDriver(onErrorJustReturn: []), noDataIsValid: noDataResult.asDriver(onErrorJustReturn: false))
    }
}
