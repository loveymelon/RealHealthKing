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
    let lastChat: ChatHistoryModel?
    
    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
        case updatedAt
        case participants
        case lastChat
    }
    
    init(roomId: String = "", updatedAt: String = "", participants: [UserInform] = [], lastChat: ChatHistoryModel? = nil) {
        self.roomId = roomId
        self.updatedAt = updatedAt
        self.participants = participants
        self.lastChat = lastChat
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
    
    init(userId: String = "", nick: String = "", profileImage: String? = nil) {
        self.userId = userId
        self.nick = nick
        self.profileImage = profileImage
    }
}

// 채팅방 리스트 모델
struct ChatRoomsModel: Decodable {
    let data: [ChatRoomModel]
    let lastChat: ChatHistoryModel
    
    
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

// 채팅 기록 모델
struct ChatHistoryModel: Decodable {
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

struct ChatModels: Decodable {
    let data: [ChatHistoryModel]
}

struct ChatPostModel: Codable {
    let content: String?
    let files: [String]
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.files = try container.decode([String].self, forKey: .files)
    }
}


