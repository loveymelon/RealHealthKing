//
//  PostsModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/17/24.
//

import Foundation

struct PostsModel: Codable {
    let data: [Posts]
}

struct Posts: Codable {
    let postId: String?
    let productId: String?
    let title: String?
    let content: String?
    let files: [String]
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case productId = "product_id"
        case title
        case content
        case files
    }
 
}

struct PostTest: Encodable {
    let productId: String?
    let title: String?
    let content: String?
    let files: [String]
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case title
        case content
        case files
    }
}
