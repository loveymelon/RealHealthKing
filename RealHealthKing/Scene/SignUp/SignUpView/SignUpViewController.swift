//
//  SignUpViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/14/24.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: BaseViewController<SignUpView> {
    
    let disposeBag = DisposeBag()
    
    let viewModel = SignUpViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureNav() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.title = "회원가입"
    }
    
    override func bind() {
        let emailTextView = mainView.emailTextFieldView.textFieldView.textField.rx
        let passwordTextView =  mainView.passwordTextFieldView.textFieldView.textField.rx
        let checkPasswordTextView = mainView.checkPasswordTextFieldView.textFieldView.textField.rx
        let nickTextView = mainView.nickTextFieldView.textFieldView.textField.rx
        
        let emailText = emailTextView.text.orEmpty.asObservable()
        
        let tapCheckButton = mainView.emailCheckButton.rx.tap.withLatestFrom(mainView.emailTextFieldView.textFieldView.textField.rx.text.orEmpty.asObservable()).asObservable()
        
        let editedPassword = passwordTextView.text.orEmpty.asObservable()
        
        let checkPasswordValue = checkPasswordTextView.text.orEmpty.asObservable()
        
        let editedNick = nickTextView.text.orEmpty.asObservable()
        
        let tapSignUpButton = mainView.signUpButton.rx.tap.asObservable()
        
        let input = SignUpViewModel.Input(emailText: emailText, checkButtonInput: tapCheckButton, passwordInput: editedPassword, checkPasswordValue: checkPasswordValue, nickInput: editedNick, signUpButtonInput: tapSignUpButton)
        
        let output = viewModel.transform(input: input)
        
        // ViewModel X
//        emailTextView.controlEvent(.editingDidBegin).map { false }.bind(to: mainView.emailTextFieldView.helperView.rx.isHidden).disposed(by: disposeBag)
        
        passwordTextView.controlEvent(.editingDidBegin).map { false }.bind(to: mainView.passwordTextFieldView.helperView.rx.isHidden).disposed(by: disposeBag)
        
        checkPasswordTextView.controlEvent(.editingDidBegin).map { false }.bind(to: mainView.checkPasswordTextFieldView.helperView.rx.isHidden).disposed(by: disposeBag)
        
        nickTextView.controlEvent(.editingDidBegin).map { false }.bind(to: mainView.nickTextFieldView.helperView.rx.isHidden).disposed(by: disposeBag)
        
        // ViewModel Output
        output.checkButtonIs.drive(with: self) { owner, isInvalid in
            owner.mainView.emailCheckButton.isEnabled = isInvalid
            owner.mainView.emailTextFieldView.helperView.isHidden = isInvalid
        }.disposed(by: disposeBag)
        
        output.isEmailValid.drive(with: self) { owner, isInvalid in

            let helperView = owner.mainView.emailTextFieldView.helperView
            
            if isInvalid {
                helperView.isHidden = !isInvalid
                helperView.label.text = "사용가능한 이메일입니다."
                helperView.label.textColor = .green
                helperView.imageView.tintColor = .green
                helperView.imageView.image = UIImage(systemName: "checkmark.circle")
            } else {
                helperView.label.text = "이메일 형식이 맞지 않습니다."
                helperView.label.textColor = .red
                helperView.imageView.tintColor = .red
                helperView.imageView.image = UIImage(systemName: "exclamationmark.circle")
            }
        }.disposed(by: disposeBag)
        output.isPasswordValid.drive(with: self) { owner, isInvalid in
            let helperView = owner.mainView.passwordTextFieldView.helperView
            
            if isInvalid {
                helperView.label.text = "사용가능한 비밀번호입니다."
                helperView.label.textColor = .green
                helperView.imageView.tintColor = .green
                helperView.imageView.image = UIImage(systemName: "checkmark.circle")
            } else {
                helperView.label.text = "비밀번호는 8자 이상 20자 이하여야 dd합니다."
                helperView.label.textColor = .red
                helperView.imageView.tintColor = .red
                helperView.imageView.image = UIImage(systemName: "exclamationmark.circle")
            }
        }.disposed(by: disposeBag)
        output.isCheckPasswordValid.drive(with: self) { owner, isInvalid in
            let helperView = owner.mainView.checkPasswordTextFieldView.helperView
            
            if isInvalid {
                helperView.label.text = "비밀번호가 일치합니다."
                helperView.label.textColor = .green
                helperView.imageView.tintColor = .green
                helperView.imageView.image = UIImage(systemName: "checkmark.circle")
            } else {
                helperView.label.text = "비밀번호가 일치하지 않습니다."
                helperView.label.textColor = .red
                helperView.imageView.tintColor = .red
                helperView.imageView.image = UIImage(systemName: "exclamationmark.circle")
            }
        }.disposed(by: disposeBag)
        output.isNickValid.drive(with: self) { owner, isInvalid in
            let helperView = owner.mainView.nickTextFieldView.helperView
            
            if isInvalid {
                helperView.label.text = "사용가능한 닉네임입니다."
                helperView.label.textColor = .green
                helperView.imageView.tintColor = .green
                helperView.imageView.image = UIImage(systemName: "checkmark.circle")
            } else {
                helperView.label.text = "닉네임은 2글자 이상 8자 이하이여야 합니다."
                helperView.label.textColor = .red
                helperView.imageView.tintColor = .red
                helperView.imageView.image = UIImage(systemName: "exclamationmark.circle")
            }
        }.disposed(by: disposeBag)
        
        output.isSignUpButtonEnabled.drive(with: self) { owner, isValid in
            
            owner.mainView.signUpButton.isEnabled = isValid
            
            if isValid {
                owner.mainView.signUpButton.backgroundColor = .green
            }
        }.disposed(by: disposeBag)
        
    }

}
