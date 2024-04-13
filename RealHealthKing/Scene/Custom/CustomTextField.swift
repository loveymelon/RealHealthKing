//
//  CustomTextField.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/13/24.
//

import UIKit
import Then

class CustomTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        backgroundColor = .clear
        textColor = .white
        tintColor = .white
        autocorrectionType = .no
        spellCheckingType = .no
    }
    
}
