//
//  InfoLabel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/13/24.
//

import UIKit

class InfoLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        textColor = .white
    }
    
}
