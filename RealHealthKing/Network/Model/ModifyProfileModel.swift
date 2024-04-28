//
//  ModifyProfileModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/28/24.
//

import Foundation

struct ModifyProfileModel: Encodable {
    let nick: String
    let profile: Data
    
    enum CodingKeys: String, CodingKey {
        case nick
        case profile
    }
}
