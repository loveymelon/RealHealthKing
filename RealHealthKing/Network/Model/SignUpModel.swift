//
//  SignUpModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/14/24.
//

import Foundation

struct UserQuery: Codable {
    let email: String
    let password: String?
    let nick: String
}
