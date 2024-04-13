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
    
    let emailTextFieldView = TextFieldView().then {
        $0.infoLabel.text = "이메일 주소"
    }
    
    let passwordTextFieldView = TextFieldView().then {
        $0.infoLabel.text = "비밀번호"
        $0.textField.isSecureTextEntry = true
        $0.secureButton.isHidden = false
        $0.secureButton.isEnabled = true
    }
    
    let signInButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.setTitle("로그인", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        $0.isEnabled = false
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
    
    var emailConstraint: Constraint?
    var passwordConstraint: Constraint?
    
    private let textViewHeight: CGFloat = 48
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        
        [emailTextFieldView, passwordTextFieldView, signInButton].forEach { item in
            stackView.addArrangedSubview(item)
        }
        
        addSubview(stackView)
        addSubview(signUpButton)
    }
    
    override func configureLayout() {
        
        stackView.snp.makeConstraints { make in
            make.center.equalTo(snp.center)
            make.horizontalEdges.equalTo(snp.horizontalEdges).inset(30)
            make.height.equalTo(textViewHeight * 3 + 36)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide.snp.horizontalEdges)
            make.height.equalTo(textViewHeight)
        }
        
    }
    
}
