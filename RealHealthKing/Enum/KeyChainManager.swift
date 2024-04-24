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
            keychain.get(KeyChainKeys.userId.rawValue) ?? "empty"
        }
        set {
            keychain.set(KeyChainKeys.userId.rawValue, forKey: newValue)
        }
    }
    
    var accessToken: String {
        get {
            keychain.get(KeyChainKeys.accessToken.rawValue) ?? "empty"
        }
        set {
            keychain.set(KeyChainKeys.accessToken.rawValue, forKey: newValue)
        }
    }
    
    var refreshToken: String {
        get {
            keychain.get(KeyChainKeys.refreshToken.rawValue) ?? "empty"
        }
        set {
            keychain.set(KeyChainKeys.refreshToken.rawValue, forKey: newValue)
        }
    }
    
}
