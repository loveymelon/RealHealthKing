//
//  TokenModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/13/24.
//

import Foundation

struct TokenModel: Codable {
    let accessToken: String
    let refreshToken: String?
    let userId: String?
    
    
    enum CodingKeys: String, CodingKey {
        case accessToken
        case refreshToken
        case userId = "user_id"
    }
    
    init(accessToken: String, refreshToken: String, userId: String? = nil) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.userId = userId
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accessToken = try container.decode(String.self, forKey: .accessToken)
        self.refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken)
        self.userId = try container.decodeIfPresent(String.self, forKey: .userId)
    }
}
