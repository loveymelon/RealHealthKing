//
//  ProfileViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/25/24.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: BaseViewController<ProfileView> {
    
    let a = BehaviorRelay(value: Array(0...30))
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.scrollView.contentSize.height = UIScreen.main.bounds.height + 20
    }
    
    override func bind() {
        a.bind(to: mainView.collectionView.rx.items(cellIdentifier: "cell")) { index, item, cell in
            cell.backgroundColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
        }.disposed(by: disposeBag)
    }

}
