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

struct Posts: Codable {
    
    let postId: String?
    let productId: String?
    let title: String?
    let content: String?
    let files: [String]
    var likes: [String]
    let creator: Creator
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case productId = "product_id"
        case title
        case content
        case files
        case likes
        case creator
    }
    
    init(postId: String? = "", productId: String? = "", title: String? = "", content: String? = "", files: [String] = [], likes: [String] = [], creator: [Creator] = []) {
        self.postId = postId
        self.productId = productId
        self.title = title
        self.content = content
        self.files = files
        self.likes = likes
        self.creator = creator
    }
    
    mutating func changeLikeValue(likeValue: [String]) {
        likes = likeValue
    }
    
}

struct Creator: Codable {
    let userId: String
    let nick: String
    let profileImage: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case profileImage
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
