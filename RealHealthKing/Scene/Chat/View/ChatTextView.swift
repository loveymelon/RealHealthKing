//
//  ChatTextView.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/18/24.
//

import UIKit
import Then
import SnapKit

class ChatTextView: UIView {

    let userTextView = InputTextView().then {
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .lightGray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ChatTextView: UIConfigureProtocol {
    func configureUI() {
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        addSubview(userTextView)
    }
    
    func configureLayout() {
        userTextView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.greaterThanOrEqualTo(32)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
    }
}
