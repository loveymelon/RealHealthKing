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
    
    enum CodingKeys: CodingKey {
        case accessToken
        case refreshToken
    }
    
    init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accessToken = try container.decode(String.self, forKey: .accessToken)
        self.refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken) ?? ""
    }
}
