//
//  TextFieldViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/13/24.
//

import Foundation
import RxSwift
import RxCocoa

class TextFieldViewModel: ViewModelType {
    struct Input {
        let textFieldEndEdit: Observable<String>
    }
    
    struct Output {
        let textInfoLayoutUpdate: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let resultTextField = BehaviorRelay(value: false)
        
        input.textFieldEndEdit.map { !$0.isEmpty }.subscribe { check in
            resultTextField.accept(check)
        }.disposed(by: disposeBag)
        
        return Output(textInfoLayoutUpdate: resultTextField.asDriver())
    }
}
