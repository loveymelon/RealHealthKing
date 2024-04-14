//
//  SignUpViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/14/24.
//

import UIKit

class SignUpViewController: BaseViewController<SignUpView> {

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.mainView.backgroundColor = .white
    }
    
    override func configureNav() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.title = "회원가입"
        
        
    }

}
