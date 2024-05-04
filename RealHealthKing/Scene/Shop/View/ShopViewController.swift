//
//  ShopViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/4/24.
//

import UIKit
import RxSwift
import RxCocoa

class ShopViewController: BaseViewController<ShopView> {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func bind() {
        Observable.of("d", "d").bind(to: mainView.tableView.rx.items(cellIdentifier: ShopTableViewCell.identifier, cellType: ShopTableViewCell.self)) { index, item, cell in
            print(item)
        }.disposed(by: disposeBag)
        
        mainView.tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }

}

extension ShopViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
