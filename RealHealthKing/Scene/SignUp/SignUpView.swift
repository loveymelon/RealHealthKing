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

    let emailTextFieldView = TextFieldView().then {
        $0.infoLabel.text = "이메일 주소"
    }
    
    let emailCheckButton = UIButton().then {
        $0.setTitle("중복\n확인", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.titleLabel?.numberOfLines = 0
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 10
    }
    
    let emailHelperView = HelperView().then {
        $0.label.text = "이메일이메일이메일"
        $0.label.textColor = .white
        $0.imageView.tintColor = .white
    }
    
    let emailCehckStackView = UIStackView().then {
        $0.spacing = 15
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.alignment = .fill
    }
    
    let emailStackView = UIStackView().then {
        $0.spacing = 5
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.alignment = .fill
    }
    
    let passwordTextFieldView = TextFieldView().then {
        $0.infoLabel.text = "비밀번호"
    }
    
    let checkPasswordTextFieldView = TextFieldView().then {
        $0.infoLabel.text = "비밀번호 확인"
    }
    
    let nickTextFieldView = TextFieldView().then {
        $0.infoLabel.text = "닉네임"
    }
    
    let stackView = UIStackView().then {
        $0.spacing = 32
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    
    private let textViewHeight: CGFloat = 48
    
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
        
        [emailCehckStackView, emailHelperView].forEach { view in
            emailStackView.addArrangedSubview(view)
        }
        
        [emailStackView, passwordTextFieldView, checkPasswordTextFieldView, nickTextFieldView].forEach { textField in
            stackView.addArrangedSubview(textField)
        }
        
        addSubview(stackView)
    }
    
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.center.equalTo(snp.center)
            make.horizontalEdges.equalTo(snp.horizontalEdges).inset(30)
            make.height.equalTo(textViewHeight * 4 + 128)
        }
        
        emailCheckButton.snp.makeConstraints { make in
            make.height.equalTo(emailTextFieldView.snp.height)
            make.width.equalTo(emailTextFieldView.snp.width).multipliedBy(0.2)
        }
        
    }
    
}
