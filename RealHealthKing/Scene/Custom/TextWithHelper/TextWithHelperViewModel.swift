//
//  TextWithHelperViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/14/24.
//

import Foundation
import RxSwift
import RxCocoa

class TextWithHelperViewModel: ViewModelType {
    struct Input {
        let textFieldEndEdit: Observable<String>
    }
    
    struct Output {
        let textInfoLayoutUpdate: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let resultTextField = BehaviorRelay(value: false)
        
        input.textFieldEndEdit.map { text in
            print(text)
            return !text.isEmpty
        }.subscribe { check in
            print(check)
            resultTextField.accept(check)
        }.disposed(by: disposeBag)
        
        return Output(textInfoLayoutUpdate: resultTextField.asDriver())
    }
}
