//
//  SignInViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignInViewModel: ViewModelType {
    
    struct Input {
        let signInButtonTap: Observable<Void>
    }
    
    struct Output {

    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        input.signInButtonTap.subscribe { _ in
            <#code#>
        }.disposed(by: disposeBag)
        
        return Output()
    }
    
}
