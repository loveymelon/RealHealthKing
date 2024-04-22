//
//  TargetType.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/13/24.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var version: String { get }
    var path: String { get }
    var header: [String: String] { get }
    var parameters: String? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
    
}

extension TargetType {
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL() // url로 변환
        
        var urlRequest = try URLRequest(url: url.appendingPathComponent(version + path), method: method, headers: HTTPHeaders(header))
        
        urlRequest.httpBody = parameters?.data(using: .utf8)
        urlRequest.httpBody = body
        
        return urlRequest
    }
    
    func postURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL() // url로 변환
        
        var urlRequest = try URLRequest(url: url.appendingPathComponent(version + path), method: method, headers: HTTPHeaders(header))
        
        urlRequest.httpBody = parameters?.data(using: .utf8)
        urlRequest.httpBody = body
        
        let limit = URLQueryItem(name: "limit", value: "15")
        
        let productid = URLQueryItem(name: "product_id", value: "abc222")
        
        urlRequest.url?.append(queryItems: [limit, productid])
        
        return urlRequest
    }
    
}
