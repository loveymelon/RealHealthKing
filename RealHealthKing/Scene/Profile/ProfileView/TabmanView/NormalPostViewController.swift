//
//  NormalPostViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/11/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol CollectionTapProtocol: AnyObject {
    func collectionTap(vc: UIViewController)
}

class NormalPostViewController: BaseViewController<TabBaseView> {
    
    let viewModel = TabViewModel()
    let disposeBag = DisposeBag()
    
    weak var delegate: CollectionTapProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.productId = "myLoveGym"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func bind() {
        
        let inputViewDidTrigger = rx.viewWillAppear.map { _ in }
        
        let collectionIndex = mainView.collectionView.rx.willDisplayCell.asObservable()
        
        let input = TabViewModel.Input(inputViewWillTrigger: inputViewDidTrigger, inputCollectionViewIndex: collectionIndex)
        
        let output = viewModel.transform(input: input)
        
        mainView.collectionView.rx.modelSelected(Posts.self).bind(with: self) { owner, item in
            
            let vc = DetailViewController()
            guard let postId = item.postId else { return }
            
            vc.postId.accept(postId)
            owner.navigationController?.pushViewController(vc, animated: true)
            
            owner.delegate?.collectionTap(vc: vc)
        }.disposed(by: disposeBag)
        
        output.outputPostDatas.drive(mainView.collectionView.rx.items(cellIdentifier: SearchCollectionViewCell.identifier, cellType: SearchCollectionViewCell.self)) { index, item, cell in
            
            let url = APIKey.baseURL.rawValue + NetworkVersion.version.rawValue + "/" + (item.files.first ?? "empty")
            
            cell.postImageView.downloadImage(imageUrl: url)
            
        }.disposed(by: disposeBag)
        
        output.outputNoData.drive(with: self) { owner, isValid in
            owner.mainView.noDataView.isHidden = isValid
            owner.mainView.collectionView.isHidden = !isValid
        }.disposed(by: disposeBag)
    }

}
