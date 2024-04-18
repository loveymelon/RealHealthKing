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
    
    static func createLogin(query: LoginQuery) -> Single<Result<TokenModel, AppError>> {
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
                                single(.success(.failure(AppError.networkError(netError))))
                            } else if let statusCode = response.response?.statusCode, let netError = LoginError(rawValue: statusCode) {
                                single(.success(.failure(AppError.loginError(netError))))
                            }
                            single(.success(.failure(AppError.unowned)))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func duplicateEmail(model: EmailCheckModel) -> Single<Result<Bool, AppError>> {
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
                                single(.success(.failure(AppError.networkError(netError))))
                            } else if let statusCode = response.response?.statusCode, let netError = DuplicateError(rawValue: statusCode) {
                                single(.success(.failure(AppError.duplicateError(netError))))
                            } else if let statusCode = response.response?.statusCode, statusCode == 200 {
                                single(.success(.success(true)))
                            }
                            single(.success(.failure(AppError.unowned)))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func createAccount(query: UserQuery) -> Single<Result<UserQuery, AppError>> {
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
                                single(.success(.failure(AppError.networkError(netError))))
                            } else if let statusCode = response.response?.statusCode, let netError = SignUpError(rawValue: statusCode) {
                                single(.success(.failure(AppError.signUpError(netError))))
                            }
                            single(.success(.failure(AppError.unowned)))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func fetchPosts() {
        do {
            let urlRequest = try Router.postFetch.postURLRequest()
            
            AF.request(urlRequest, interceptor: NetworkInterceptor())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: PostsModel.self) { response in
                    switch response.result {
                    case .success(let data):
                        print(data.data)
                    case .failure(let error):
                        print(error)
                    }
                }
        } catch {
            print(error)
        }
    }
}

