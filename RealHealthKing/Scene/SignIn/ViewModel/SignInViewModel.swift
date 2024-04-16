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
        let networkError: Driver<Error>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let networkResult = BehaviorRelay<Error>(value: NetworkError.blank)
        
        input.signInButtonTap.flatMap { text in
            return NetworkManager.createLogin(query: LoginQuery(email: text.0, password: text.1)).asObservable()
        }.subscribe { result in
            
            switch result {
            case .success(let data):
                UserDefaults.standard.set(data.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(data.refreshToken, forKey: "refreshToken")
                networkResult.accept(NetworkError.noError)
            case .failure(let error):
                networkResult.accept(error)
            }
            
        }.disposed(by: disposeBag)
        
        
        
        return Output(networkError: networkResult.asDriver())
    }
    
}
