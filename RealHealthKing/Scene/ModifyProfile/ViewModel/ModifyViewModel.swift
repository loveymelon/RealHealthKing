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
        let inputNickName: Observable<String>
        let inputProfileImage: Observable<String>
        let inputNick: Observable<String>
    }
    
    struct Output {
        let outputNick: Driver<String>
        let outputProfileImage: Driver<String>
        let outputNickValid: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    
    func transform(input: Input) -> Output {
        let nickResult = BehaviorRelay(value: "")
        let profileImageResult = BehaviorRelay(value: "")
        let nickValidResult = BehaviorRelay(value: false)
        
        input.inputNickName.subscribe { text in
            nickResult.accept(text)
        }.disposed(by: disposeBag)
        
        input.inputProfileImage.subscribe { text in
            
            if text.isEmpty {
                profileImageResult.accept("")
            } else {
                profileImageResult.accept(text)
            }
        }.disposed(by: disposeBag)
     
        input.inputNick.map { $0.count >= 2 && $0.count <= 8 }.bind(to: nickValidResult).disposed(by: disposeBag)
        
        return Output(outputNick: nickResult.asDriver(), outputProfileImage: profileImageResult.asDriver(), outputNickValid: nickValidResult.asDriver())
    }
    
    
}
