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
                
                KeyChainManager.shared.accessToken = data.accessToken
                KeyChainManager.shared.refreshToken = data.refreshToken ?? "empty"
                KeyChainManager.shared.userId = data.userId ?? "empty"
                
                networkSuccess.accept(true)
            case .failure(let error):
                networkSuccess.accept(false)
                networkResult.accept(error.description)
            }
            
        }.disposed(by: disposeBag)
        
        
        return Output(networkSuccess: networkSuccess.asDriver(), networkError: networkResult.asDriver())
    }
    
}
