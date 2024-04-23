//
//  LikeQuery.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/23/24.
//

import Foundation

struct LikeQuery: Codable {
    let likeStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case likeStatus = "like_status"
    }
}
