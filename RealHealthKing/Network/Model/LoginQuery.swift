//
//  LoginQuery.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/13/24.
//

import Foundation

struct LoginQuery: Codable {
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
    }
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try container.decode(String.self, forKey: .email)
        self.password = try container.decode(String.self, forKey: .password)
    }
}
