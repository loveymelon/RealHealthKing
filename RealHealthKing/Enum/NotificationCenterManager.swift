//
//  NotificationCenterManager.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/24/24.
//

import Foundation

enum NotificationCenterManager: NotificationCenterProtocol {
    case like
    
    var name: Notification.Name {
        switch self {
        case .like:
            return Notification.Name("Like")
        }
    }
    
    
}
