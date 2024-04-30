//
//  ProfileModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/26/24.
//

import Foundation

struct ProfileModel: Decodable {
    let userId: String
    let email: String?
    let nick: String
    let profileImage: String?
    let followers: [Followers]
    let following: [Following]
    let posts: [String]
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nick
        case profileImage
        case followers
        case following
        case posts
    }
    init(userId: String = "", email: String? = "", nick: String = "", profileImage: String? = nil, followers: [Followers] = [], following: [Following] = [], posts: [String] = []) {
        self.userId = userId
        self.email = email
        self.nick = nick
        self.profileImage = profileImage
        self.followers = followers
        self.following = following
        self.posts = posts
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.nick = try container.decode(String.self, forKey: .nick)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
        self.followers = try container.decode([Followers].self, forKey: .followers)
        self.following = try container.decode([Following].self, forKey: .following)
        self.posts = try container.decode([String].self, forKey: .posts)
    }
}

struct Followers: Decodable {
    let userId: String
    let nick: String
//    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
//        case profileImage
    }
}

struct Following: Decodable {
    let userId: String
    let nick: String
//    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
//        case profileImage
    }
}
