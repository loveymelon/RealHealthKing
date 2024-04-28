//
//  CommentModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/29/24.
//

import Foundation

struct CommentModel: Encodable {
    let content: String
}

struct CommentsModel: Codable {
    let commentId: String
    let content: String
    let createdAt: String
    let creator: Creator
    
    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case content
        case createdAt
        case creator
    }
    
    init(commentId: String = "", content: String = "", createdAt: String = "", creator: Creator = Creator()) {
        self.commentId = commentId
        self.content = content
        self.createdAt = createdAt
        self.creator = creator
    }
}
