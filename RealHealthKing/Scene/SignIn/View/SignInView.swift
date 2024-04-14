//
//  SignInView.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/12/24.
//

import UIKit
import Then
import SnapKit
import TextFieldEffects

class SignInView: BaseView {
    
    let emailTextFieldView = TextViewWithHelperView().then {
        $0.textFieldView.infoLabel.text = "이메일 주소"
    }
    
    let passwordTextFieldView = TextViewWithHelperView().then {
        $0.textFieldView.infoLabel.text = "비밀번호"
        $0.textFieldView.textField.isSecureTextEntry = true
        $0.textFieldView.secureButton.isHidden = false
        $0.textFieldView.secureButton.isEnabled = true
    }
    
    let signInButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.setTitle("로그인", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        $0.isEnabled = true
    }
    
    private let stackView = UIStackView().then {
        $0.spacing = 18
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    
    let signUpButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setTitle("회원가입", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    private let textViewHeight: CGFloat = 62
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        
        [emailTextFieldView, passwordTextFieldView].forEach { item in
            stackView.addArrangedSubview(item)
        }
        
        addSubview(stackView)
        addSubview(signInButton)
        addSubview(signUpButton)
    }
    
    override func configureLayout() {
        
        stackView.snp.makeConstraints { make in
            make.center.equalTo(snp.center)
            make.horizontalEdges.equalTo(snp.horizontalEdges).inset(30)
            make.height.equalTo(textViewHeight * 2 + 18)
        }
        
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(18)
            make.horizontalEdges.equalTo(stackView.snp.horizontalEdges)
            make.height.equalTo(48)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide.snp.horizontalEdges)
            make.height.equalTo(textViewHeight)
        }
        
    }
    
}
