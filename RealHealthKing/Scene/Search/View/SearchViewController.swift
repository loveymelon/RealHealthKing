//
//  SearchViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/24/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: BaseViewController<SearchView> {
    
    private let viewModel = SearchViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureNav() {
        super.configureNav()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        mainView.searchController.searchBar.placeholder = "전체라는 단어를 넣으면 전체보기입니다."
        mainView.searchController.hidesNavigationBarDuringPresentation = false
        mainView.searchBar.tintColor = .red
        mainView.searchBar.setTextFieldBackground(color: .white)
        
        navigationItem.searchController = mainView.searchController
        navigationItem.title = "검색"
        
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    override func bind() {
        
        let search = mainView.searchBar.rx
        
        let willAppear = rx.viewWillAppear.map { _ in }
        
        let searchButtonTrigger = search.searchButtonClicked.withLatestFrom(search.text.orEmpty.asObservable())
        
        let collectionIndex = mainView.collectionView.rx.willDisplayCell.asObservable()
        
        let input = SearchViewModel.Input(viewWillAppearTrigger: willAppear, searchButtonTap: searchButtonTrigger, searchCancelTap: search.cancelButtonClicked, collectionCellIndex: collectionIndex)
        
        let output = viewModel.transform(input: input)
        
        output.noData.drive(with: self) { owner, isValid in
            owner.mainView.noDataView.isHidden = !isValid
            owner.mainView.collectionView.isHidden = isValid
        }.disposed(by: disposeBag)
        
        output.postDatas.drive(mainView.collectionView.rx.items(cellIdentifier: SearchCollectionViewCell.identifier, cellType: SearchCollectionViewCell.self)) { index, item, cell in
            
            guard let imageUrl = item.files.first else { return }
            
            cell.postImageView.downloadImage(imageUrl: imageUrl)
            
        }.disposed(by: disposeBag)
        
        mainView.collectionView.rx.modelSelected(Posts.self).bind(with: self) { owner, item in
            let vc = DetailViewController()
            guard let postId = item.postId else { return }
            
            vc.postId.accept(postId)
            owner.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
    }

}
