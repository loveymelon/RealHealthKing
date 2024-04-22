//
//  Router.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/13/24.
//

import Foundation
import Alamofire
import KeychainSwift


enum Router {
    case login(query: LoginQuery)
    case emailCheck(model: EmailCheckModel)
    case signUp(model: UserQuery)
    case tokenRefresh(model: TokenModel)
    case postFetch
    case imageUpload
    case posting(model: PostTest)
//    case imageFetch
//    case withdraw
//    case fetchPost
//    case uploadPost
}

extension Router: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var version: String {
        return NetworkVersion.version.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login:
            return .post
        case .emailCheck:
            return .post
        case .signUp:
            return .post
        case .tokenRefresh:
            return .get
        case .postFetch:
            return .get
        case .imageUpload:
            return .post
        case .posting:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/users/login"
        case .emailCheck:
            return "/validation/email"
        case .signUp:
            return "/users/join"
        case .tokenRefresh:
            return "/auth/refresh"
        case .postFetch:
            return "/posts"
        case .imageUpload:
            return "/posts/files"
        case .posting:
            return "/posts"
        }
    }
    
    var header: [String : String] {
        
        let keyChain = KeychainSwift()
        
        switch self {
        case .login:
            return [HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue]
        case .emailCheck:
            return [HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue]
        case .signUp:
            return [HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue]
        case .tokenRefresh:
            return [HTTPHeader.authorization.rawValue: keyChain.get("accessToken") ?? "empty",
                    HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue,
                    HTTPHeader.refresh.rawValue: keyChain.get("refreshToken") ?? "Empty"]
        case .postFetch:
            return [HTTPHeader.authorization.rawValue: keyChain.get("accessToken") ?? "empty",
                    HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue]
        case .imageUpload:
            return [HTTPHeader.authorization.rawValue: keyChain.get("accessToken") ?? "empty",
                    HTTPHeader.contentType.rawValue: HTTPHeader.multipart.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue]
        case .posting:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue,
                HTTPHeader.authorization.rawValue: keyChain.get("accessToken") ?? "empty"
            ]
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .login(let query):
            let encoder = JSONEncoder() // 서버에서 알 수 있게 JSON으로 인코딩 하도록 도와주는것 (swift에서 만듦)
            encoder.keyEncodingStrategy =
                .convertToSnakeCase
            
            return try? encoder.encode(query)
        case .emailCheck(let model):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy =
                .convertToSnakeCase
            
            return try? encoder.encode(model)
        case .signUp(let model):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy =
                .convertToSnakeCase
            
            return try? encoder.encode(model)
        case .tokenRefresh:
            return .none
        case .postFetch:
            return .none
        case .imageUpload:
            return .none
        case .posting(let model):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy =
                .convertToSnakeCase
            
            return try? encoder.encode(model)
        }
    }
}
