//
//  TextViewWithHelperView.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

class TextViewWithHelperView: UIView {

    let textFieldView = TextFieldView()
    
    let helperView = HelperView().then {
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TextViewWithHelperView: UIConfigureProtocol {
    func configureUI() {
        configureHierarchy()
        configureLayout()
        
    }
    
    func configureHierarchy() {
        [textFieldView, helperView].forEach { view in
            addSubview(view)
        }
    }
    
    func configureLayout() {
        textFieldView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        
        helperView.snp.makeConstraints { make in
            make.top.equalTo(textFieldView.snp.bottom).offset(3)
            make.height.equalTo(textFieldView.snp.height).multipliedBy(0.3)
            make.leading.equalTo(textFieldView.snp.leading)
        }
    }
    
    
}
