//
//  NotificationCenter+Extension.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/24/24.
//

import Foundation
import RxSwift

extension NotificationCenterProtocol {
    func addObserver() -> Observable<Any?> {
        return NotificationCenter.default.rx.notification(name).map { $0.object }
    }
    
    func post(object: Any? = nil) {
        NotificationCenter.default.post(name: name, object: object, userInfo: nil)
    }
}
