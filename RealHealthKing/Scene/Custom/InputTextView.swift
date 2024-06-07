//
//  InputTextView.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/18/24.
//

import UIKit
import Then
import SnapKit

final class InputTextView: UITextView {
    
    let sendButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        $0.backgroundColor = HKColor.assistant.color
        $0.tintColor = HKColor.background.color
        $0.layer.cornerRadius = 10
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InputTextView: UIConfigureProtocol {
    func configureUI() {
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        addSubview(sendButton)
    }
    
    func configureLayout() {
        
        sendButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(5)
            make.width.equalTo(30)
        }
        
    }
    
}
