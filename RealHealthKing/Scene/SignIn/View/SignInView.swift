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
    
    private let emailTextFieldView = UIView().then {
        $0.backgroundColor = .darkGray
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    let emailInfoLabel = UILabel().then {
        $0.text = "이메일 주소"
        $0.textColor = .white
    }
    
    let emailTextField = UITextField().then {
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.tintColor = .white
        $0.autocapitalizationType = .none // 첫 문자 항상 소문자로 시작
        $0.autocorrectionType = .no // 자동 수정 활성화
        $0.spellCheckingType = .no // 맞춤법 검사 활성화
        $0.keyboardType = .emailAddress
    }
    
    private let passwordTextFieldView = UIView().then {
        $0.backgroundColor = .darkGray
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }

    let passwordInfoLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.textColor = .white
    }
    
    let passwordTextField = UITextField().then {
        $0.backgroundColor = .black
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.tintColor = .white
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.isSecureTextEntry = true
    }
    
    let passwordSecureButton = UIButton().then {
        $0.setTitle("표시", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
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
        [emailTextField, emailInfoLabel].forEach { item in
            emailTextFieldView.addSubview(item)
        }
        
        [passwordTextField, passwordInfoLabel, passwordSecureButton].forEach { item in
            passwordTextFieldView.addSubview(item)
        }
        
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
        
        [emailTextField, passwordTextField].forEach { textField in
            textField.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(15)
                make.bottom.equalToSuperview().inset(2)
                make.horizontalEdges.equalToSuperview().inset(8)
            }
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide.snp.horizontalEdges)
            make.height.equalTo(textViewHeight)
        }
        
        emailInfoLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(emailTextFieldView.snp.horizontalEdges).inset(8)
            emailConstraint = make.centerY.equalTo(emailTextFieldView.snp.centerY).constraint
        }
        
        passwordInfoLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(passwordTextFieldView.snp.horizontalEdges).inset(8)
            passwordConstraint = make.centerY.equalTo(passwordTextFieldView.snp.centerY).constraint
        }
        
        passwordSecureButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(passwordTextFieldView.snp.verticalEdges).inset(15)
            make.trailing.equalTo(passwordTextFieldView.snp.trailing).inset(8)
        }
        
    }
    
}
