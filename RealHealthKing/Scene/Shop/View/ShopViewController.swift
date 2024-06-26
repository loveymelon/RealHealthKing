//
//  ShopViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/4/24.
//

import UIKit
import RxSwift
import RxCocoa
import iamport_ios
import WebKit

final class ShopViewController: BaseViewController<ShopView> {

    private let viewModel = ShopViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func configureNav() {
        super.configureNav()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: mainView.plusButton)
        
        setNavigationBarTitleLabel(title: "중고물품")
    }
    
    override func bind() {
        let viewWillAppearTrigger = rx.viewWillAppear.map { _ in }
        
        let input = ShopViewModel.Input(viewWillAppearTrigger: viewWillAppearTrigger)
        
        let output = viewModel.transform(input: input)
        
        mainView.plusButton.rx.tap.bind(with: self) { owner, _ in
            owner.navigationController?.pushViewController(ShopPostViewController(), animated: true)
        }.disposed(by: disposeBag)
        
        mainView.tableView.rx.modelSelected(Posts.self).bind(with: self) { owner, data in
            let vc = MarketViewController()
            guard let postId = data.postId else { return }
            
            vc.postId.accept(postId)
            
            owner.navigationController?.pushViewController(vc, animated: true)
            
        }.disposed(by: disposeBag)
        
        output.shopDatas.drive(mainView.tableView.rx.items(cellIdentifier: ShopTableViewCell.identifier, cellType: ShopTableViewCell.self)) { index, item, cell in
            
            cell.configureCell(data: item)
            
            cell.delegate = self
            
        }.disposed(by: disposeBag)
        
        output.noDataIsValid.drive(with: self) { owner, isValid in
            owner.mainView.tableView.isHidden = !isValid
            owner.mainView.noDataView.isHidden = isValid
        }.disposed(by: disposeBag)
        
    }

}

extension ShopViewController: PurchaseProtocol {
    
    func purchaseButtonTap(payment: IamportPayment, postData: Posts) {
        let vc = PurchaseViewController()
        
        vc.payment = payment
        vc.viewModel.postData = postData
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
