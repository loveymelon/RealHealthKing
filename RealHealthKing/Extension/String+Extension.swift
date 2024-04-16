//
//  String+Extension.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/15/24.
//

import Foundation

extension String {
    func checkEmail(str: String) -> Bool {
        let regex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        return  NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: str)
    }
}
