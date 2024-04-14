//
//  NetworkError.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/14/24.
//

import Foundation

enum NetworkError: Int, Error {
    case blank = 0 // 처음 들어왔을때
    case unownedError = 1
    case noError = 2 // 성공케이스
    case noSesacKey = 420
    case overCall = 429
    case invalidURL = 444
    case severError = 500
}

enum LoginError: Int, Error {
    case omission = 400 // 누락
    case checkCount = 401 // 미가입 유저, 비번 확인
}
