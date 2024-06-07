//
//  LauchScreenViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/28/24.
//

import UIKit
import RxSwift
import RxCocoa

final class LauchScreenViewController: BaseViewController<LauchScreenView> {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    let viewModel = LauchViewModel()
    
    let disposeBag = DisposeBag()
    
    override func bind() {
        let viewWill = rx.viewWillAppear.map { _ in }
        
        let input = LauchViewModel.Input(inputViewWillAppear: viewWill)
        
        let output = viewModel.transform(input: input)
        
        output.outputViewResult.drive(with: self) { owner, isValid in
            if isValid {
                owner.view.window?.rootViewController = TabBarViewController()
            } else {
                owner.view.window?.rootViewController = UINavigationController(rootViewController: SignInViewController())
            }
            
            owner.view.window?.makeKeyAndVisible()
        }.disposed(by: disposeBag)

    }
    
}
