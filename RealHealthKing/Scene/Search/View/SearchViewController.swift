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
    
    override func configureNav() {
//        navigationItem.largeTitleDisplayMode = .always
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//        navigationItem.title = "검색"
//        
//        
//        navigationController?.navigationBar.barPosition = .
        mainView.searchController.searchBar.placeholder = "Search"
        mainView.searchController.hidesNavigationBarDuringPresentation = false
        navigationController?.navigationBar.isTranslucent = false
        mainView.searchBar.tintColor = .red

        navigationItem.searchController = mainView.searchController
    }
    
    override func bind() {
        
        let search = mainView.searchBar.rx
        
        let willAppear = rx.viewWillAppear.map { _ in}
        
        let input = SearchViewModel.Input(viewWillAppearTrigger: willAppear, searchButtonTap: search.searchButtonClicked, searchCancelTap: search.cancelButtonClicked, searchText: search.text.orEmpty)
        
        let output = viewModel.transform(input: input)
        
        output.postDatas.drive(mainView.collectionView.rx.items(cellIdentifier: SearchCollectionViewCell.identifier, cellType: SearchCollectionViewCell.self)) { index, item, cell in
            
            let url = APIKey.baseURL.rawValue + NetworkVersion.version.rawValue + "/" + item.files.first!
            
            cell.postImageView.downloadImage(imageUrl: url, width: cell.bounds.width, height: cell.bounds.height)
            
        }.disposed(by: disposeBag)
    }

}
