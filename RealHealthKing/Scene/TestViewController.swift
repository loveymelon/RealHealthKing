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
        
        let button = UIButton().then {
            $0.setTitle("next", for: .normal)
            $0.setTitleColor(.red, for: .normal)
        }
        
        self.view.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(30)
        }
        
        button.rx.tap.bind(with: self) { owner, _ in
            owner.navigationController?.pushViewController(NextViewController(), animated: true)
        }.disposed(by: disposeBag)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NetworkManager.fetchPosts()
    }
    

}
