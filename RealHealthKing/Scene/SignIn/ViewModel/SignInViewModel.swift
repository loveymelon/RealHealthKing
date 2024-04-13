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
        let signInButtonTap: Observable<(String, String)>
    }
    
    struct Output {
        
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        input.signInButtonTap.flatMap { text in
            return NetworkManager.createLogin(query: LoginQuery(email: text.0, password: text.1))
        }.subscribe { tokenModel in
            print(tokenModel.accessToken)
            UserDefaults.standard.set(tokenModel.accessToken, forKey: "accessToken")
            UserDefaults.standard.set(tokenModel.refreshToken, forKey: "refreshToken")
        }.disposed(by: disposeBag)

        
        return Output()
    }
    
}
