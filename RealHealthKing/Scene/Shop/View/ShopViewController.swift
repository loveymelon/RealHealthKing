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

    let viewModel = ShopViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func bind() {
        let viewWillAppearTrigger = rx.viewWillAppear.map { _ in }
        
        let input = ShopViewModel.Input(viewWillAppearTrigger: viewWillAppearTrigger)
        
        let output = viewModel.transform(input: input)
        
        output.shopDatas.drive(mainView.tableView.rx.items(cellIdentifier: ShopTableViewCell.identifier, cellType: ShopTableViewCell.self)) { index, item, cell in
            
            cell.configureCell(data: item)
            
        }.disposed(by: disposeBag)
        
        output.noDataIsValid.drive(with: self) { owner, isValid in
            owner.mainView.tableView.isHidden = !isValid
            owner.mainView.noDataView.isHidden = isValid
        }.disposed(by: disposeBag)
    }

}

