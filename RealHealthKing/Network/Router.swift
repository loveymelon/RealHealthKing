//
//  Router.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/13/24.
//

import Foundation
import Alamofire

enum Router {
    case login(query: LoginQuery)
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
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/users/login"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .login:
            return [HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.secretKey.rawValue]
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
        }
    }
}
