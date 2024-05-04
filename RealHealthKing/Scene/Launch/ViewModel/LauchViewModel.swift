//
//  LauchViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/28/24.
//

import Foundation
import RxSwift
import RxCocoa

class LauchViewModel: ViewModelType {
    
    struct Input {
        let inputViewWillAppear: Observable<Void>
    }
    
    struct Output {
        let outputViewResult: Driver<Bool>
        
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let viewWillResult = PublishRelay<Bool>()
        
        input.inputViewWillAppear.flatMap { NetworkManager.fetchPosts() }.subscribe { result in
            switch result {
            case .success(let data):
                viewWillResult.accept(!data.data.isEmpty)
            case .failure(let error):
                print(error)
            }
        } onError: { error in
            print(error)
        }.disposed(by: disposeBag)
        
        return Output(outputViewResult: viewWillResult.asDriver(onErrorJustReturn: false))
    }
}
