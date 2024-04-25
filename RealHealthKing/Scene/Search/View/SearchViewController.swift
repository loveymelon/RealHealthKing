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
    
    let viewModel = SearchViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bind() {
        
        let willAppear = rx.viewWillAppear.map { _ in}
        
        let input = SearchViewModel.Input(viewWillAppearTrigger: willAppear)
        
        let output = viewModel.transform(input: input)
        
        output.postDatas.drive(mainView.collectionView.rx.items(cellIdentifier: SearchCollectionViewCell.identifier, cellType: SearchCollectionViewCell.self)) { index, item, cell in
            
            let url = APIKey.baseURL.rawValue + NetworkVersion.version.rawValue + "/" + item.files.first!
            
            cell.postImageView.downloadImage(imageUrl: url, width: cell.bounds.width, height: cell.bounds.height)
            
        }.disposed(by: disposeBag)
    }

}
