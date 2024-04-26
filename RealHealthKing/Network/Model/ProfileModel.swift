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
    
    init(userId: String = "", email: String = "", nick: String = "", profileImage: String? = nil, follwers: [Follwers]? = nil, following: [Fllowing]? = nil, posts: [String] = []) {
        self.userId = userId
        self.email = email
        self.nick = nick
        self.profileImage = profileImage
        self.follwers = follwers
        self.following = following
        self.posts = posts
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
