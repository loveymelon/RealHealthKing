//
//  PaymentModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/7/24.
//

import Foundation

struct PaymentModel: Decodable {
    let data: [PaymentDatas]
}

struct PaymentDatas: Decodable {
    let paymentId: String
    let buyerId: String
    let postId: String
    let merchantUid: String
    let productName: String
    let price: Int
    let paidAt: String
    
    enum CodingKeys: String, CodingKey {
        case paymentId = "payment_id"
        case buyerId = "buyer_id"
        case postId = "post_id"
        case merchantUid = "merchant_uid"
        case productName
        case price
        case paidAt
    }
}
