//
//  SignInViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/12/24.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

class SignInViewController: BaseViewController<SignInView> {

    let viewModel = SignInViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        mainView.signUpButton.rx.tap.bind(with: self) { owner, _ in
            owner.mainView.emailTextFieldView.helperView.isHidden = true
            
            owner.mainView.emailTextFieldView.textFieldView.textField.text = nil
            owner.mainView.passwordTextFieldView.textFieldView.textField.text = nil
            
            owner.mainView.endEditing(true)
            
            self.navigationController?.pushViewController(SignUpViewController(), animated: true)
        }.disposed(by: disposeBag)
        
        let emailPassword = Observable.combineLatest(mainView.emailTextFieldView.textFieldView.textField.rx.text.orEmpty.asObservable(), mainView.passwordTextFieldView.textFieldView.textField.rx.text.orEmpty.asObservable()).asObservable()
        let signInButtonTap = mainView.signInButton.rx.tap.withLatestFrom(emailPassword)
        
        let input = SignInViewModel.Input(signInButtonTap: signInButtonTap)
        
        let output = viewModel.transform(input: input)
        
        output.networkError.drive(with: self) { owner, networkResult in
            if networkResult != "" {
                owner.mainView.makeToast(networkResult, position: .center, title: "에러!!!")
            }
        }.disposed(by: disposeBag)
        
        output.networkSuccess.drive(with: self) { owner, isValid in
            if isValid {
                owner.navigationController?.pushViewController(HomeViewController(), animated: true)
                print(isValid)
            }
        }.disposed(by: disposeBag)
    }

}
