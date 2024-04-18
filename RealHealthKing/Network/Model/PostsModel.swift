//
//  PostsModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/17/24.
//

import Foundation

struct PostsModel: Decodable {
    let data: [Posts]
}

struct Posts: Decodable {
    let postId: String?
    let productId: String?
    let title: String?
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case productId = "product_id"
        case title
        case content
    }
}
