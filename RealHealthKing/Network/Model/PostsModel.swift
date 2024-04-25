//
//  PostsModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/17/24.
//

import Foundation

struct PostsModel: Codable {
    var data: [Posts]
}

struct Posts: Codable , Equatable{
    let postId: String?
    let productId: String?
    let title: String?
    let content: String?
    let files: [String]
    var likes: [String]
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case productId = "product_id"
        case title
        case content
        case files
        case likes
    }
    
    init(postId: String? = "", productId: String? = "", title: String? = "", content: String? = "", files: [String] = [], likes: [String] = []) {
        self.postId = postId
        self.productId = productId
        self.title = title
        self.content = content
        self.files = files
        self.likes = likes
    }
    
    mutating func changeLikeValue(likeValue: [String]) {
        likes = likeValue
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
