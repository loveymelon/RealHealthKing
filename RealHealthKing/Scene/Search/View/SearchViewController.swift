//
//  SearchViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/24/24.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: BaseViewController<SearchView> {
    
    let a = BehaviorRelay(value: Array(0...30))
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bind() {
        a.bind(to: mainView.collectionView.rx.items(cellIdentifier: "cell")) { index, item, cell in
            print(item)
            cell.backgroundColor = .blue
        }.disposed(by: disposeBag)
    }

}
