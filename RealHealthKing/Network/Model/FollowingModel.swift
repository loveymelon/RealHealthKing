//
//  FollowingModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/30/24.
//

import Foundation

struct Follow: Decodable {
    let nick: String
    let opponentNick: String
    let followingStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case nick
        case opponentNick = "opponent_nick"
        case followingStatus = "following_status"
    }
}
