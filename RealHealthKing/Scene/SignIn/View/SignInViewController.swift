//
//  SignInViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/12/24.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewController: BaseViewController<SignInView> {

    let viewModel = SignInViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bind() {
        mainView.signUpButton.rx.tap.bind(with: self) { owner, _ in
            self.navigationController
        }.disposed(by: disposeBag)
        
        let emailPassword = Observable.combineLatest(mainView.emailTextFieldView.textField.rx.text.orEmpty.asObservable(), mainView.passwordTextFieldView.textField.rx.text.orEmpty.asObservable()).asObservable()
        let signInButtonTap = mainView.signInButton.rx.tap.withLatestFrom(emailPassword)
        
        let input = SignInViewModel.Input(signInButtonTap: signInButtonTap)
        
        let output = viewModel.transform(input: input)
        
        
        
    }

}
