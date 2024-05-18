//
//  InputTextView.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/18/24.
//

import UIKit
import Then
import SnapKit

class InputTextView: UITextView {

    let plusButton = UIButton().then {
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
    }
    
    let sendButton = UIButton()

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
        addSubview(plusButton)
        addSubview(sendButton)
    }
    
    func configureLayout() {
        plusButton.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(5)
        }
        
        sendButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(5)
        }
    }
    
    
}
