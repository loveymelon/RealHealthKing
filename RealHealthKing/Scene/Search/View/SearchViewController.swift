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
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        mainView.searchController.searchBar.placeholder = "Search"
        mainView.searchController.hidesNavigationBarDuringPresentation = false
        mainView.searchBar.tintColor = .red
        mainView.searchBar.setTextFieldBackground(color: .white)
        
        navigationItem.searchController = mainView.searchController
        navigationItem.title = "검색"
        
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
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
        
        mainView.collectionView.rx.modelSelected(Posts.self).bind(with: self) { owner, item in
            let vc = DetailViewController()
            guard let postId = item.postId else { return }
            
            vc.postId.accept(postId)
            owner.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
    }

}
