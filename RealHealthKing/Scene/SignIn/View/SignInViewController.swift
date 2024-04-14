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
            self.navigationController?.pushViewController(SignUpViewController(), animated: true)
        }.disposed(by: disposeBag)
        
        let emailPassword = Observable.combineLatest(mainView.emailTextFieldView.textField.rx.text.orEmpty.asObservable(), mainView.passwordTextFieldView.textField.rx.text.orEmpty.asObservable()).asObservable()
        let signInButtonTap = mainView.signInButton.rx.tap.withLatestFrom(emailPassword)
        
        let input = SignInViewModel.Input(signInButtonTap: signInButtonTap)
        
        let output = viewModel.transform(input: input)
        
        output.networkError.drive(with: self) { owner, networkResult in
            switch networkResult {
            case NetworkError.noSesacKey:
                print("noSesacKey")
            case NetworkError.overCall:
                print("overCall")
            case NetworkError.invalidURL:
                print("invalidURL")
            case NetworkError.severError:
                print("severError")
            case NetworkError.unownedError:
                print("unowned")
            case NetworkError.noError:
                print("success")
            case NetworkError.blank:
                print("blank")
            case LoginError.omission:
                owner.mainView.helperView.label.text = "이메일 혹은 비밀번호가 빠졌습니다!"
                owner.mainView.helperView.isHidden = false
            case LoginError.checkCount:
                owner.mainView.helperView.label.text = " 비밀번호가 틀렸습니다"
                owner.mainView.helperView.isHidden = false
            default:
                print("default")
            }
        }.disposed(by: disposeBag)
        
    }

}
