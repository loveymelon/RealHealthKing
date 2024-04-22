//
//  UIView+Extension.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/22/24.
//

import UIKit

extension UIView: ReusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
