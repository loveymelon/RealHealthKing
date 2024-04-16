//
//  SignUpView.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/14/24.
//

import UIKit
import Then
import SnapKit

class SignUpView: BaseView {

    let emailTextFieldView = TextViewWithHelperView().then {
        $0.textFieldView.infoLabel.text = "이메일 주소"
        $0.helperView.label.text = "이메일 형식이 맞지 않습니다."
        $0.helperView.isHidden = false
    }
    
    let emailCheckButton = UIButton().then {
        $0.setTitle("중복\n확인", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.titleLabel?.numberOfLines = 0
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 10
    }
    
    let emailCehckStackView = UIStackView().then {
        $0.spacing = 15
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.alignment = .fill
    }
    
    let passwordTextFieldView = TextViewWithHelperView().then {
        $0.textFieldView.infoLabel.text = "비밀번호"
        $0.helperView.label.text = "비밀번호는 8자 이상 20자 이하여야 합니다."
//        $0.helperView.backgroundColor = .red
    }
    
    let checkPasswordTextFieldView = TextViewWithHelperView().then {
        $0.textFieldView.infoLabel.text = "비밀번호 확인"
        $0.helperView.label.text = "비밀번호와 일치하지 않습니다."
    }
    
    let nickTextFieldView = TextViewWithHelperView().then {
        $0.textFieldView.infoLabel.text = "닉네임"
        $0.helperView.label.text = "닉네임은 2글자 이상 8자 이하이여야 합니다."
    }
    
    let stackView = UIStackView().then {
        $0.spacing = 10
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    
    let signUpButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        $0.isEnabled = false
    }
    
    private let textViewHeight: CGFloat = 64
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        [emailTextFieldView, emailCheckButton].forEach { view in
            emailCehckStackView.addArrangedSubview(view)
        }
        
        [emailCehckStackView, passwordTextFieldView, checkPasswordTextFieldView, nickTextFieldView].forEach { view in
            stackView.addArrangedSubview(view)
        }
        
        addSubview(stackView)
        addSubview(signUpButton)
    }
    
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.center.equalTo(snp.center)
            make.horizontalEdges.equalTo(snp.horizontalEdges).inset(30)
            make.height.equalTo(textViewHeight * 4 + 30)
        }
        
        emailCheckButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextFieldView.snp.top)
//            make.bottom.equalTo(emailTextFieldView.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.7)
            make.width.equalTo(emailTextFieldView.snp.width).multipliedBy(0.2)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(stackView)
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.height.equalTo(48)
        }
        
    }
    
}
