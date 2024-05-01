//
//  SearchViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/24/24.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel: ViewModelType {
    struct Input {
        let viewWillAppearTrigger: Observable<Void>
        let searchButtonTap: ControlEvent<Void>
        let searchCancelTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
    }
    
    struct Output {
        let postDatas: Driver<[Posts]>
    }
    
    var disposeBag = DisposeBag()
    
    
    func transform(input: Input) -> Output {
        let postsDatas = BehaviorRelay<[Posts]>(value: [])
        
        input.viewWillAppearTrigger.subscribe { _ in
            NetworkManager.fetchPosts { result in
                switch result {
                case .success(let data):
                    postsDatas.accept(data.data)
                case .failure(let failure):
                    print(failure)
                }
            }
        }.disposed(by: disposeBag)
        
        return Output(postDatas: postsDatas.asDriver())
    }
}
