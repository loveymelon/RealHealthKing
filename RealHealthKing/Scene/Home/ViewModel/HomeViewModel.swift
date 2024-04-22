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
        let viewDidLoadTrigger: Observable<Void>
    }
    
    struct Output {
        let postsDatas: Driver<[Posts]>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let resultPostsDatas = BehaviorRelay<[Posts]>(value: [])
        
        input.viewDidLoadTrigger.subscribe { _ in
            NetworkManager.fetchPosts { result in
                switch result {
                case .success(let data):
                    resultPostsDatas.accept(data)
                case .failure(let error):
                    print(error.description)
                }
            }
        }.disposed(by: disposeBag)
        
        return Output(postsDatas: resultPostsDatas.asDriver())
    }
}
