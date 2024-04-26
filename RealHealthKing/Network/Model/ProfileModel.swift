//
//  ProfileModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/26/24.
//

import Foundation

struct ProfileModel: Decodable {
    let userId: String
    let email: String
    let nick: String
    let profileImage: String?
    let follwers: [Follwers]?
    let following: [Fllowing]?
    let posts: [String]
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nick
        case profileImage
        case follwers
        case following
        case posts
    }
}

struct Follwers: Decodable {
    let userId: String?
    let nick: String?
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case profileImage
    }
}

struct Fllowing: Decodable {
    let userId: String?
    let nick: String?
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case profileImage
    }
}
