//
//  CommentModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/29/24.
//

import Foundation

struct CommentsModel: Codable {
    let commentId: String?
    let content: String
    let createdAt: String?
    let creator: Creator?
    
    init(commentId: String? = nil, content: String = "", createdAt: String? = nil, creator: Creator? = nil) {
        self.commentId = commentId
        self.content = content
        self.createdAt = createdAt
        self.creator = creator
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.commentId = try container.decodeIfPresent(String.self, forKey: .commentId)
        self.content = try container.decode(String.self, forKey: .content)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        self.creator = try container.decodeIfPresent(Creator.self, forKey: .creator)
    }
    
}
