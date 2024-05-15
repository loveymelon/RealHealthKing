//
//  ChatModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/16/24.
//

import Foundation

struct ChatUserId: Encodable {
    let opponentId: String
    
    enum CodingKeys: String, CodingKey {
        case opponentId = "opponent_id"
    }
}

struct ChatModel: Decodable {
    let roomId: String
    let updatedAt: Date
    let participants: [UserInform]
}

struct UserInform: Decodable {
    let userId: String
    let nick: String
    let profileImage: String?
}
