//
//  MarketPostViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/11/24.
//

import UIKit
import RxSwift
import RxCocoa

class MarketPostViewController: BaseViewController<TabBaseView> {

    let viewModel = TabViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.productId = "healthProduct"
    }

    override func bind() {
        let inputViewViewDidTrigger = rx.viewWillAppear.map { _ in }
        
        let collectionIndex = mainView.collectionView.rx.willDisplayCell.asObservable()
        
        let input = TabViewModel.Input(inputViewWillTrigger: inputViewViewDidTrigger, inputCollectionViewIndex: collectionIndex)
        
        let output = viewModel.transform(input: input)
        
        output.outputPostDatas.drive(mainView.collectionView.rx.items(cellIdentifier: SearchCollectionViewCell.identifier, cellType: SearchCollectionViewCell.self)) { index, item, cell in
            
            guard let imageUrl = item.files.first else { return }
            
            cell.postImageView.downloadImage(imageUrl: imageUrl)
            
        }.disposed(by: disposeBag)
        
        output.outputNoData.drive(with: self) { owner, isValid in
            owner.mainView.noDataView.isHidden = isValid
            owner.mainView.collectionView.isHidden = !isValid
        }.disposed(by: disposeBag)
    }
    
}
