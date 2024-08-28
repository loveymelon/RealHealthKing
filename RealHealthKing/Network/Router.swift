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
    case posting(model: Posts)
    case postLike(postId: String, query: LikeQuery)
    case profileFetch
    case accessPostDetails(postID: String)
    case userPosts
    case modifyProfile(model: ModifyProfileModel)
    case otherProfile(userId: String)
    case otherPosts(userId: String)
    case comment(model: CommentsModel, postId: String)
    case following(userId: String)
    case unfollow(userId: String)
    case hashTagSearch
    case purchase(model: PurchaseModel)
    case paymentHistory
    case withdraw
    case chat(model: ChatUserId)
    case chatRoom
    case chatHistory(roomId: String)
    case chatPost(roomId: String, model: ChatPostModel)
    case chatImageUpload(roomId: String)
}

extension Routmer: TargetType {
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
        case .userPosts:
            return .get
        case .modifyProfile:
            return .put
        case .otherProfile:
            return .get
        case .otherPosts:
            return .get
        case .comment:
            return .post
        case .following:
            return .post
        case .unfollow:
            return .delete
        case .hashTagSearch:
            return .get
        case .purchase:
            return .post
        case .paymentHistory:
            return .get
        case .withdraw:
            return .get
        case .chat:
            return .post
        case .chatRoom:
            return .get
        case .chatHistory:
            return .get
        case .chatPost:
            return .post
        case .chatImageUpload:
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
        case .postLike(let postId, _):
            return "/posts/\(postId)/like"
        case .profileFetch:
            return "/users/me/profile"
        case .accessPostDetails(postID: let postID):
            return "/posts/\(postID)"
        case .userPosts:
            return "/posts/users/\(KeyChainManager.shared.userId)"
        case .modifyProfile:
            return "/users/me/profile"
        case .otherProfile(let id):
            return "/users/\(id)/profile"
        case .otherPosts(let id):
            return "/posts/users/\(id)"
        case .comment(_, let postId):
            return "/posts/\(postId)/comments"
        case .following(userId: let userId):
            return "/follow/\(userId)"
        case .unfollow(userId: let userId):
            return "/follow/\(userId)"
        case .hashTagSearch:
            return "/posts/hashtags"
        case .purchase:
            return "/payments/validation"
        case .paymentHistory:
            return "/payments/me"
        case .withdraw:
            return "/users/withdraw"
        case .chat:
            return "/chats"
        case .chatRoom:
            return "/chats"
        case .chatHistory(let roomId):
            return "/chats/\(roomId)"
        case .chatPost(let roomId, _):
            return "/chats/\(roomId)"
        case .chatImageUpload(let roomId):
            return "/chats/\(roomId)"
        }
    }
    
    var header: [String : String] {
        
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
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.authorization.rawValue: KeyChainManager.shared.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue
            ]
            
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
        case .postLike:
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
        case .userPosts:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.authorization.rawValue: KeyChainManager.shared.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue
            ]
        case .modifyProfile:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.multipart.rawValue,
                HTTPHeader.authorization.rawValue: KeyChainManager.shared.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue,
                
            ]
        case .otherProfile:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.authorization.rawValue: KeyChainManager.shared.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue
            ]
        case .otherPosts:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.authorization.rawValue: KeyChainManager.shared.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue
            ]
        case .comment:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.authorization.rawValue: KeyChainManager.shared.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue
            ]
        case .following:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.authorization.rawValue: KeyChainManager.shared.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue
            ]
        case .unfollow:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.authorization.rawValue: KeyChainManager.shared.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue
            ]
        case .hashTagSearch:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.authorization.rawValue: KeyChainManager.shared.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue
            ]
        case .purchase:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.authorization.rawValue: KeyChainManager.shared.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue
            ]
        case .paymentHistory:
            return [
                HTTPHeader.authorization.rawValue: KeyChainManager.shared.accessToken,
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue
            ]
        case .withdraw:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.authorization.rawValue: KeyChainManager.shared.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue
            ]
        case .chat:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue,
                HTTPHeader.authorization.rawValue: KeyChainManager.shared.accessToken
            ]
        case .chatRoom:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue,
                HTTPHeader.authorization.rawValue: KeyChainManager.shared.accessToken
            ]
        case .chatHistory:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue,
                HTTPHeader.authorization.rawValue: KeyChainManager.shared.accessToken
            ]
        case .chatPost:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue,
                HTTPHeader.authorization.rawValue: KeyChainManager.shared.accessToken
            ]
        case .chatImageUpload:
            return [
                HTTPHeader.authorization.rawValue: KeyChainManager.shared.accessToken,
                HTTPHeader.contentType.rawValue: HTTPHeader.multipart.rawValue,
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
        case .postLike(_, let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy =
                .convertToSnakeCase
            
            return try? encoder.encode(query)
        case .profileFetch:
            return .none
        case .accessPostDetails:
            return .none
        case .userPosts:
            return .none
        case .modifyProfile:
            return .none
        case .otherProfile:
            return .none
        case .otherPosts:
            return .none
        case .comment(let model, _):
            let encoder = JSONEncoder()
            
            return try? encoder.encode(model)
        case .following:
            return .none
        case .unfollow:
            return .none
        case .hashTagSearch:
            return .none
        case .purchase(let model):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy =
                .convertToSnakeCase
            
            return try? encoder.encode(model)
        case .paymentHistory:
            return .none
        case .withdraw:
            return .none
        case .chat(model: let model):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy =
                .convertToSnakeCase
            
            return try? encoder.encode(model)
        case .chatRoom:
            return .none
        case .chatHistory:
            return nil
        case .chatPost(_, let model):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy =
                .convertToSnakeCase
            
            return try? encoder.encode(model)
        case .chatImageUpload:
            return .none
        }
    }
}
