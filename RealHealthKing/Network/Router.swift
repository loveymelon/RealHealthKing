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
    case postLike(postId: String, query: LikeQuery)
    case profileFetch
    case accessPostDetails(postID: String)
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
        case .postLike:
            return .post
        case .profileFetch:
            return .get
        case .accessPostDetails:
            return .get
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
        case .postLike(let postId, let likeValue):
            return "/posts/\(postId)/like"
        case .profileFetch:
            return "/users/me/profile"
        case .accessPostDetails(postID: let postID):
            return "/posts/\(postID)"
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
            return [HTTPHeader.authorization.rawValue: KeyChainManager.shared.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue,
                    HTTPHeader.refresh.rawValue: KeyChainManager.shared.refreshToken]
        case .postFetch:
            return [HTTPHeader.authorization.rawValue: KeyChainManager.shared.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue]
        case .imageUpload:
            return [HTTPHeader.authorization.rawValue: KeyChainManager.shared.accessToken,
                    HTTPHeader.contentType.rawValue: HTTPHeader.multipart.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue]
        case .posting:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue,
                HTTPHeader.authorization.rawValue: KeyChainManager.shared.accessToken
            ]
        case .postLike(postId: let postId):
            return [
                HTTPHeader.authorization.rawValue: KeyChainManager.shared.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue,
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue
            ]
        case .profileFetch:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.authorization.rawValue: KeyChainManager.shared.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue
            ]
        case .accessPostDetails:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.authorization.rawValue:
                    KeyChainManager.shared.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue
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
        case .postLike(let postId, let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy =
                .convertToSnakeCase
            
            return try? encoder.encode(query)
        case .profileFetch:
            return .none
        case .accessPostDetails:
            return .none
        }
    }
}
