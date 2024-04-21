//
//  TestViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/17/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class TestViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NetworkManager.fetchPosts()
    }
    

}
