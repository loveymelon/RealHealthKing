//
//  PurchaseModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/5/24.
//

import Foundation

struct PurchaseModel: Codable {
    let impUid: String?
    let postId: String?
    let productName: String?
    let price: Int?
    
    enum CodingKeys: String, CodingKey {
        case impUid = "imp_uid"
        case postId = "post_id"
        case productName
        case price
    }
}
