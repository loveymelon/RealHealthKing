//
//  RealmError.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/19/24.
//

import Foundation

enum RealmError: Error {
    case createFail
    case updateFail(text: String)
    case deleteFail
    case unknownError
}
