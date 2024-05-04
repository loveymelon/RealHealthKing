//
//  UITextField+Extension.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/5/24.
//

import UIKit

extension UITextField {
    
    func setPlaceholder(string: String, color: UIColor) {
        attributedPlaceholder = NSAttributedString(string: string, attributes: [.foregroundColor: color])
    }
    
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func setClearButton(with image: UIImage, mode: UITextField.ViewMode) {
            let clearButton = UIButton(type: .custom)
            clearButton.setImage(image, for: .normal)
            clearButton.frame = CGRect(x: 0, y: 0, width: 5, height: 40)
            clearButton.contentMode = .scaleAspectFit
            clearButton.addTarget(self, action: #selector(UITextField.clear(sender:)), for: .touchUpInside)
            self.rightView = clearButton
            self.rightViewMode = mode
        }
        
        @objc
        private func clear(sender: AnyObject) {
            self.text = ""
        }
}
