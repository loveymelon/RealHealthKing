//
//  Date+Extension.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/19/24.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = .current
        
        dateFormatter.dateFormat = "yyyy-dd-MM'T'HH:mm:ssZZZZZ"
    
        return dateFormatter.string(from: self)
    }
}
