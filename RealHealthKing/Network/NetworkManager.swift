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
    
    static func createLogin(query: LoginQuery) -> Single<TokenModel> {
        return Single<TokenModel>.create { single in
            do {
                let urlRequest = try Router.login(query: query).asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: TokenModel.self) { response in
                        switch response.result {
                        case .success(let loginModel):
                            single(.success(loginModel))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
}
