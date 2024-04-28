//
//  LauchScreenView.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/28/24.
//

import UIKit
import Then
import SnapKit

class LauchScreenView: BaseView {
    
    let lauchLabel = UILabel().then {
        $0.text = "Launch"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        addSubview(lauchLabel)
    }
    
    override func configureLayout() {
        lauchLabel.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(300)
        }
    }
    
}
