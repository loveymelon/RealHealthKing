//
//  UILabel+Extension.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/22/24.
//

import UIKit

extension UILabel {
    var lineCount: Int {
        let text = (self.text ?? "") as NSString

        let maxSize = CGSize(width: frame.size.width,
                             height: CGFloat(MAXFLOAT))
        let textHeight = text.boundingRect(with: maxSize,
                                           options: .usesLineFragmentOrigin,
                                           attributes: [.font: font as Any],
                                           context: nil).height
        let lineHeight = font.lineHeight
        
        return Int(ceil(textHeight / lineHeight))
    }
    
    
}
