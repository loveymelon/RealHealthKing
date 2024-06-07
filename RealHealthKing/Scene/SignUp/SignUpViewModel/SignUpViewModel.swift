//
//  SignUpViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/15/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel: ViewModelType {
    struct Input {
        let emailText: Observable<String>
        let checkButtonInput: Observable<String>
        let passwordInput: Observable<String>
        let checkPasswordValue: Observable<String>
        let nickInput: Observable<String>
        let signUpButtonInput: Observable<Void>
    }
    
    struct Output {
        let checkButtonIs: Driver<Bool>
        let networkError: Driver<String>
        let isEmailValid: Driver<Bool>
        let isPasswordValid: Driver<Bool>
        let isCheckPasswordValid: Driver<Bool>
        let isNickValid: Driver<Bool>
        let isSignUpButtonEnabled: Driver<Bool>
        let signUpComplete: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let checkButtonIs = BehaviorRelay(value: false)
        let emailValidResult = PublishRelay<Bool>()
        let passwordValidResult = BehaviorRelay(value: false)
        let checkPasswordValidResult = BehaviorRelay(value: false)
        let nickValidResult = BehaviorRelay(value: false)
        let isSignUpButtonEnabled = BehaviorRelay(value: false)
        
        let networkResult = BehaviorRelay(value: "")
        let signUpButtonResult = PublishRelay<Bool>()
        
        input.emailText.map { $0.checkEmail(str: $0) }.bind(to: checkButtonIs).disposed(by: disposeBag)
        
        input.passwordInput.map { $0.count >= 8 && $0.count <= 20 }.bind(to: passwordValidResult).disposed(by: disposeBag)
        
        Observable.combineLatest(input.passwordInput, input.checkPasswordValue).map { text in
            return text.0 == text.1
        }.bind(to: checkPasswordValidResult).disposed(by: disposeBag)
        
        input.nickInput.map { $0.count >= 2 && $0.count <= 8 }.bind(to: nickValidResult).disposed(by: disposeBag)
        
        input.checkButtonInput.flatMap { NetworkManager.duplicateEmail(model: EmailCheckModel(email: $0)) }.subscribe { result in
            
            switch result {
            case .success(let data):
                print(data)
                emailValidResult.accept(data)
            case .failure(let error):
                print(error)
                networkResult.accept(error.description)
            }
        }.disposed(by: disposeBag)
        
        // 모든 조건 다시 한 번 검사 해서 넣는 과정
        let allValid = Observable.combineLatest(
            emailValidResult.asObservable(),
            passwordValidResult.asObservable(),
            checkPasswordValidResult.asObservable(),
            nickValidResult.asObservable()
        ).map { $0 && $1 && $2 && $3 }
        
        allValid.bind(to: isSignUpButtonEnabled)
            .disposed(by: disposeBag)
        
        let signUpRequest = input.signUpButtonInput
            .withLatestFrom(Observable.combineLatest(input.emailText, input.passwordInput, input.nickInput))
            .map { email, password, nick in
                print(email)
                return UserQuery(email: email, password: password, nick: nick)
            }.flatMap { NetworkManager.createAccount(query: $0) }
            .subscribe { result in
                switch result {
                case .success(let data):
                    signUpButtonResult.accept(true)
                case .failure(let error):
                    signUpButtonResult.accept(false)
                    networkResult.accept(error.description)
                }
            }
        
        return Output(checkButtonIs: checkButtonIs.asDriver(), networkError: networkResult.asDriver(), isEmailValid: emailValidResult.asDriver(onErrorJustReturn: false), isPasswordValid: passwordValidResult.asDriver(), isCheckPasswordValid: checkPasswordValidResult.asDriver(), isNickValid: nickValidResult.asDriver(), isSignUpButtonEnabled: isSignUpButtonEnabled.asDriver(), signUpComplete: signUpButtonResult.asDriver(onErrorJustReturn: false))
    }
}
