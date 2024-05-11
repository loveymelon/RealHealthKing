//
//  NotificationCenterManager.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/24/24.
//

import Foundation

enum NotificationCenterManager: NotificationCenterProtocol {
    case postData
    
    var name: Notification.Name {
        switch self {
        case .postData:
            return Notification.Name("postData")
        }
    }
    
    
}
