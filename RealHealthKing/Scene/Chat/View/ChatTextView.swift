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
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .lightGray
        $0.isScrollEnabled = false
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 40)
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
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
    }
}
