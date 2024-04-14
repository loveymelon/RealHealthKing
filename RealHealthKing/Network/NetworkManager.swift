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
                        case .failure(let error):
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
    
}
