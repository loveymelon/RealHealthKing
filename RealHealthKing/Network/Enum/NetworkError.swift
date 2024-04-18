//
//  NetworkError.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/14/24.
//

import Foundation

enum AppError: Error {
    case networkError(NetworkError)
    case loginError(LoginError)
    case duplicateError(DuplicateError)
    case signUpError(SignUpError)
    case unowned
    
    var description: String {
        switch self {
        case .networkError(let networkError):
            return networkError.description
        case .loginError(let loginError):
            return loginError.description
        case .duplicateError(let duplicateError):
            return duplicateError.description
        case .signUpError(let signUpError):
            return signUpError.description
        case .unowned:
            return "unowned"
        }
    }
}

enum NetworkError: Int, Error {
    case noSesacKey = 420
    case overCall = 429
    case invalidURL = 444
    case severError = 500
    
    var description: String {
        switch self {
        case .noSesacKey:
            return "noSesacKey"
        case .overCall:
            return "overCall"
        case .invalidURL:
            return "invalidURL"
        case .severError:
            return "severError"
        }
    }
}

enum LoginError: Int, Error {
    case omission = 400 // 누락
    case checkCount = 401 // 미가입 유저, 비번 확인
    
    var description: String {
        switch self {
        case .omission:
            return "omission"
        case .checkCount:
            return "checkCount"
        }
    }
}

enum DuplicateError: Int, Error {
    case emptyValue = 400
    case invalidEmail = 409
    
    var description: String {
        switch self {
        case .emptyValue:
            return "emptyValue"
        case .invalidEmail:
            return "invalidEmail"
        }
    }
}

enum SignUpError: Int, Error {
    case emptyValue = 400
    case existingUser = 409
    
    var description: String {
        switch self {
        case .emptyValue:
            return "emptyValue"
        case .existingUser:
            return "existingUser"
        }
    }
}
