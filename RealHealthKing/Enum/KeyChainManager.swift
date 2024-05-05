//
//  KeyChainManager.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/24/24.
//

import KeychainSwift

class KeyChainManager {
    static let shared = KeyChainManager()
    private let keychain = KeychainSwift()

    private init() {}
    
    private enum KeyChainKeys: String {
        case userId
        case accessToken
        case refreshToken
    }
    
    var userId: String {
        get {
            return keychain.get(KeyChainKeys.userId.rawValue) ?? "empty"
        }
        set {
            keychain.set(newValue, forKey: "userId")
        }
    }
    
    var accessToken: String {
        get {
            return keychain.get(KeyChainKeys.accessToken.rawValue) ?? "empty"
        }
        set {
            keychain.set(newValue, forKey: "accessToken")
        }
    }
    
    var refreshToken: String {
        get {
            return keychain.get(KeyChainKeys.refreshToken.rawValue) ?? "empty"
        }
        set {
            keychain.set(newValue, forKey: "refreshToken")
        }
    }
    
}
