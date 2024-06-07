//
//  HKColor.swift
//  RealHealthKing
//
//  Created by 김진수 on 6/5/24.
//

import UIKit

enum HKColor {
    case background
    case text
    case point
    case assistant
    case chatUser
    case chatOpponent
    case yellow
    
    var color: UIColor {
        return switch self {
        case .background:
                .white
        case .text:
                .black
        case .point:
            UIColor(hexCode: "#F95700", alpha: 1)
        case .assistant:
            UIColor(hexCode: "#6A7BA2", alpha: 1)
        case .chatUser:
            UIColor(hexCode: "D2DAFF", alpha: 1)
        case .chatOpponent:
            UIColor(hexCode: "AAC4FF", alpha: 1)
        case .yellow:
            UIColor(hexCode: "#FFFAE6", alpha: 1)
        }
    }
}
