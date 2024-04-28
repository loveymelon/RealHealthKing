//
//  LauchScreenViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/28/24.
//

import UIKit
import RxSwift
import RxCocoa

class LauchScreenViewController: BaseViewController<LauchScreenView> {

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
            
            print(isValid)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                
                if isValid {
                    owner.view.window?.rootViewController = UINavigationController(rootViewController: HomeViewController())
                } else {
                    owner.view.window?.rootViewController = UINavigationController(rootViewController: SignInViewController())
                }
            }
        }.disposed(by: disposeBag)
    }
    
}
