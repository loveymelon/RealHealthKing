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
    var closure: (() -> Void)?
    
    weak var delegate: CollectionTapProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.productId = "myLoveGym"
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
            
            print("height height height", self.mainView.collectionView.collectionViewLayout.collectionViewContentSize.height)
            
            self.mainView.collectionView.snp.updateConstraints { make in
//                make.top.equalTo(barInsets.bottom).offset(50)
//                make.width.equalTo(UIScreen.main.bounds.width)
                make.height.equalTo(self.mainView.collectionView.collectionViewLayout.collectionViewContentSize.height)
//                make.bottom.equalToSuperview()
            }
            
//            self.closure?()
            
            let url = APIKey.baseURL.rawValue + NetworkVersion.version.rawValue + "/" + (item.files.first ?? "empty")
            
            cell.postImageView.downloadImage(imageUrl: url)
            
        }.disposed(by: disposeBag)
        
        output.outputNoData.drive(with: self) { owner, isValid in
            owner.mainView.noDataView.isHidden = isValid
            owner.mainView.collectionView.isHidden = !isValid
        }.disposed(by: disposeBag)
        
        output.outputUpdate.drive(with: self) { owner, isValid in
            if isValid {
//                owner.closure!()
            }
        }.disposed(by: disposeBag)
    }

}
