//
//  SearchView.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/24/24.
//

import UIKit
import Then
import SnapKit

class SearchView: BaseView {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var searchBar: UISearchBar { return searchController.searchBar }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createThreeColumnSection()).then {
        $0.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        $0.backgroundColor = .black
    }
    
    let noDataView = NoDataView().then {
        $0.setText("검색결과 혹은 데이터가 없습니다!")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    static func createThreeColumnSection() -> UICollectionViewLayout {
        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/3)))
            fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let mainItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalHeight(1.0)))
        mainItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let pairItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)))
        pairItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)), repeatingSubitem: pairItem, count: 2)

        let mainWithTrailingGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(4/9)), subitems: [mainItem, trailingGroup])
        
        let tripleItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)))
        tripleItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let tripleGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/9)), repeatingSubitem: tripleItem, count: 3)
        
        let mainWithReversedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(4/9)), subitems: [trailingGroup, mainItem])
        
        let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(16/9)), subitems: [fullPhotoItem, mainWithTrailingGroup, tripleGroup, mainWithReversedGroup])

        let section = NSCollectionLayoutSection(group: nestedGroup)

        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
        
//        let inset: CGFloat = 3
//        
//        let topItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(9/16))
//        let topItem = NSCollectionLayoutItem(layoutSize: topItemSize)
//        topItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
//        
//        let bottomItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
//        let bottomItem = NSCollectionLayoutItem(layoutSize: bottomItemSize)
//        bottomItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
//        
//        let bottomGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(3/8 + 0.12))
//        let bottomGroup = NSCollectionLayoutGroup.horizontal(layoutSize: bottomGroupSize, repeatingSubitem: bottomItem, count: 3)
//        
//        let fullGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(9/16 + 0.5))
//        let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: fullGroupSize, subitems: [topItem, bottomGroup])
//        
//        let section = NSCollectionLayoutSection(group: nestedGroup)
//        
//        let layout = UICollectionViewCompositionalLayout(section: section)
//        
//        return layout
        
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                  heightDimension: .estimated(250))
//            
//            let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                  heightDimension: .estimated(250))
//            
//            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
//            let spacing = CGFloat(10)
//            group.interItemSpacing = .fixed(spacing)
//
//            let section = NSCollectionLayoutSection(group: group)
//            section.interGroupSpacing = spacing
//            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
//
//            let layout = UICollectionViewCompositionalLayout(section: section)
//            return layout
        
    }
    
    override func configureHierarchy() {
        addSubview(collectionView)
        addSubview(noDataView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        noDataView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
