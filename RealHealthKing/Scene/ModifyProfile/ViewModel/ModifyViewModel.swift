//
//  ModifyViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/27/24.
//

import Foundation
import RxCocoa
import RxSwift

final class ModifyViewModel: ViewModelType {
    
    struct Input {
        let nickInput: Observable<String>
    }
    
    struct Output {

    }
    
    var disposeBag = DisposeBag()
    
    
    func transform(input: Input) -> Output {
        let nickValidResult = BehaviorRelay(value: false)
     
        input.nickInput.map { $0.count >= 2 && $0.count <= 8 }.bind(to: nickValidResult).disposed(by: disposeBag)
        
        return Output()
    }
    
    
}
