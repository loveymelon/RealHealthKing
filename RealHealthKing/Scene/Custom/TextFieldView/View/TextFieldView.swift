//
//  TextFieldView.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/13/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class TextFieldView: UIView, UIConfigureProtocol {
    
    let textField = UITextField().then {
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.tintColor = .white
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
    }
    let infoLabel = InfoLabel()
    let secureButton = UIButton().then {
        $0.setTitle("표시", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        $0.isEnabled = false
        $0.isHidden = true
    }
    
    var infoLabelConstraint: Constraint?
    
    let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        secureButton.rx.tap.bind(with: self) { owner, _ in
            owner.textField.isSecureTextEntry.toggle()
        }.disposed(by: disposeBag)
    }
    
    func configureUI() {
        backgroundColor = .darkGray
        clipsToBounds = true
        layer.cornerRadius = 10
        
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        [textField, infoLabel, secureButton].forEach { item in
            addSubview(item)
        }
    }
    
    func configureLayout() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(snp.top).inset(15)
            make.bottom.equalTo(snp.bottom).inset(2)
            make.horizontalEdges.equalTo(snp.horizontalEdges).inset(8)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(snp.horizontalEdges).inset(8)
            infoLabelConstraint = make.centerY.equalTo(snp.centerY).constraint
        }
        
        secureButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(snp.verticalEdges).inset(15)
            make.trailing.equalTo(snp.trailing).inset(8)
        }
        
    }
    
}
