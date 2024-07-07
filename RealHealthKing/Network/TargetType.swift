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
    
    func postURLRequest(productId: String) throws -> URLRequest {
        let url = try baseURL.asURL() // url로 변환
        
        var urlRequest = try URLRequest(url: url.appendingPathComponent(version + path), method: method, headers: HTTPHeaders(header))
        
        urlRequest.httpBody = parameters?.data(using: .utf8)
        urlRequest.httpBody = body
        
        let limit = URLQueryItem(name: "limit", value: "15")
        

        let productid = URLQueryItem(name: "product_id", value: productId)
        
        urlRequest.url?.append(queryItems: [limit, productid])
        
        return urlRequest
    }
    
    func pageURLRequest(cursorValue: String, productId: String) throws -> URLRequest {
        let url = try baseURL.asURL()
        
        var urlRequest = try URLRequest(url: url.appendingPathComponent(version + path), method: method, headers: HTTPHeaders(header))
        
        let cursor = URLQueryItem(name: "next", value: cursorValue)
        let limit = URLQueryItem(name: "limit", value: "15")
        let productid = URLQueryItem(name: "product_id", value: productId)
        
        urlRequest.url?.append(queryItems: [cursor,limit, productid])
        
        return urlRequest
    }
    
    func hashPageURLRequest(hashTag: String, cursor: String) throws -> URLRequest {
        let url = try baseURL.asURL()
        
        var urlRequest = try URLRequest(url: url.appendingPathComponent(version + path), method: method, headers: HTTPHeaders(header))
        
        let hashTag = URLQueryItem(name: "hashTag", value: hashTag)
        let cursor = URLQueryItem(name: "next", value: cursor)
        let limit = URLQueryItem(name: "limit", value: "15")
        let productid = URLQueryItem(name: "product_id", value: "myLoveGym")
        
        urlRequest.url?.append(queryItems: [hashTag, cursor, limit, productid])
        
        return urlRequest
    }
    
    func asChatURLRequest(cusorDate: String) throws -> URLRequest {
        let url = try baseURL.asURL()
        
        var urlRequest = try URLRequest(url: url.appendingPathComponent(version + path), method: method, headers: HTTPHeaders(header))
        
        let cursorDate = URLQueryItem(name: "cursor_date", value: cusorDate)
        
        urlRequest.url?.append(queryItems: [cursorDate])
        
        return urlRequest
    }
}
