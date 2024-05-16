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
    let updatedAt: String
    let participants: [UserInform]
    
    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
        case updatedAt
        case participants
    }
}

struct UserInform: Decodable {
    let userId: String
    let nick: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case profileImage
    }
}

struct ChatRoomsModel: Decodable {
    let data: [ChatRoomModel]
    let lastChat: LastChatModel?
}

struct ChatRoomModel: Decodable {
    let roomId: String
    let updatedAt: String
    let participants: [UserInform]
    
    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
        case updatedAt
        case participants
    }
}

struct LastChatModel: Decodable {
    let chatId: String
    let roomId: String
    let content: String
    let createdAt: String
    let sender: UserInform
    let files: [String]
    
    enum CodingKeys: String, CodingKey {
        case chatId = "chat_id"
        case roomId = "room_id"
        case content
        case createdAt
        case sender
        case files
    }
}

struct ChatMessageModel: Decodable {
    let cursor_date: String
}

struct ChatHistoryModel: Decodable {
    let data: [LastChatModel]
}
