//
//  SignInViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/13/24.
//

import Foundation
import RxSwift
import RxCocoa
import KeychainSwift

final class SignInViewModel: ViewModelType {
    
    struct Input {
        let signInButtonTap: Observable<(String, String)>
    }
    
    struct Output {
        let networkSuccess: Driver<Bool>
        let networkError: Driver<String>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let networkResult = BehaviorRelay<String>(value: "")
        let networkSuccess = BehaviorRelay<Bool>(value: false)
        
        input.signInButtonTap.flatMap { text in
            return NetworkManager.createLogin(query: LoginQuery(email: text.0, password: text.1)).asObservable()
        }.subscribe { result in
            
            switch result {
            case .success(let data):
                let keychain = KeychainSwift()
                keychain.set(data.accessToken, forKey: "accessToken")
                keychain.set(data.refreshToken ?? "empty", forKey: "refreshToken")
                keychain.set(data.userId ?? "empty", forKey: "userId")
                networkSuccess.accept(true)
            case .failure(let error):
                networkSuccess.accept(false)
                networkResult.accept(error.description)
            }
            
        }.disposed(by: disposeBag)
        
        
        return Output(networkSuccess: networkSuccess.asDriver(), networkError: networkResult.asDriver())
    }
    
}
