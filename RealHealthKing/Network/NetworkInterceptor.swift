//
//  NetworkInterceptor.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/17/24.
//

import Foundation
import KeychainSwift
import Alamofire

class NetworkInterceptor: RequestInterceptor {
    
    let keyChain = KeychainSwift()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {

        completion(.success(urlRequest))
        
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        do {
            var urlRequest = try Router.tokenRefresh(model: TokenModel(accessToken: keyChain.get("accessToken") ?? "empty", refreshToken: keyChain.get("refreshToken") ?? "empty")).asURLRequest()
            
            AF.request(urlRequest)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: TokenModel.self) {[weak self] response in
                    
                    guard let self else { return }
                    
                    switch response.result {
                    case .success(let accessToken):
                        keyChain.set(accessToken.accessToken, forKey: "accessToken")
                        completion(.retry)
                    case .failure(let error):
                        completion(.doNotRetryWithError(error))
                    }
                }
        } catch {
            print(error)
        }
    }
}

