//
//  FollowingModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/30/24.
//

import Foundation

struct FollowingModel: Decodable {
    let nick: String
//    let opponentNick: String
//    let followingState: Bool
    
    enum CodingKeys: String, CodingKey {
        case nick
//        case opponentNick = "opponent_nick"
//        case followingState = "following_state"
    }
}
