//
//  NetworkManager.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/13/24.
//

import Foundation
import Alamofire
import RxSwift

struct NetworkManager {
    
    static func createLogin(query: LoginQuery) -> Single<Result<TokenModel, Error>> {
        return Single.create { single in
            do {
                let urlRequest = try Router.login(query: query).asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: TokenModel.self) { response in
                        switch response.result {
                        case .success(let loginModel):
                            single(.success(.success(loginModel)))
                        case .failure(_):
                            if let statusCode = response.response?.statusCode, let netError = NetworkError(rawValue: statusCode) {
                                single(.success(.failure(netError)))
                            } else if let statusCode = response.response?.statusCode, let netError = LoginError(rawValue: statusCode) {
                                single(.success(.failure(netError)))
                            }
                            single(.success(.failure(NetworkError.unownedError)))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func duplicateEmail(model: EmailCheckModel) -> Single<Result<Bool, Error>> {
        return Single.create { single in
            do {
                let urlRequest = try Router.emailCheck(model: model).asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: String.self) { response in
                        switch response.result {
                        case .success(_):
                            single(.success(.success(true)))
                        case .failure(_):
                            if let statusCode = response.response?.statusCode, let netError = NetworkError(rawValue: statusCode) {
                                single(.success(.failure(netError)))
                            } else if let statusCode = response.response?.statusCode, let netError = DuplicateError(rawValue: statusCode) {
                                single(.success(.failure(netError)))
                            } else if let statusCode = response.response?.statusCode, statusCode == 200 {
                                single(.success(.success(true)))
                            }
                            single(.success(.failure(NetworkError.unownedError)))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func createAccount(query: UserQuery) -> Single<Result<UserQuery, Error>> {
        return Single.create { single in
            do {
                let urlRequest = try Router.signUp(model: query).asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: UserQuery.self) { response in
                        switch response.result {
                        case .success(let userData):
                            single(.success(.success(userData)))
                        case .failure(_):
                            if let statusCode = response.response?.statusCode, let netError = NetworkError(rawValue: statusCode) {
                                single(.success(.failure(netError)))
                            } else if let statusCode = response.response?.statusCode, let netError = SignUpError(rawValue: statusCode) {
                                single(.success(.failure(netError)))
                            }
                            single(.success(.failure(NetworkError.unownedError)))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
}

