//
//  CountView.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/25/24.
//

import UIKit
import Then
import SnapKit

final class CountView: UIView {

    let countLabel = UILabel().then {
        $0.textColor = HKColor.text.color
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 18)
    }
    let titleLabel = UILabel().then {
        $0.textColor = HKColor.text.color
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 18)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CountView: UIConfigureProtocol {
    func configureUI() {
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        addSubview(countLabel)
        addSubview(titleLabel)
    }
    
    func configureLayout() {
        countLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(10)
            make.centerX.equalTo(countLabel)
        }
    }
    
    
}
