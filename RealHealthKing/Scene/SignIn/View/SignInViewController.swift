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
        
        let signInButton = mainView.signInButton.rx.tap.asObservable()
        
        let input = SignInViewModel.Input(signInButtonTap: signInButton)
    }

}
