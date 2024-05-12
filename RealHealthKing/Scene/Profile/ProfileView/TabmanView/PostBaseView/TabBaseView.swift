//
//  TabBaseView.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/11/24.
//

import UIKit
import Then
import SnapKit

class TabBaseView: BaseView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createThreeColumnSection()).then {
        $0.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        $0.backgroundColor = .black
        $0.isScrollEnabled = false
    }
    
    let noDataView = NoDataView().then {
        $0.setText("게시글이 없습니다")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        addSubview(collectionView)
        addSubview(noDataView)
    }
    
    
    
    override func configureLayout() {
//        collectionView.snp.makeConstraints { make in
////            make.width.equalTo(UIScreen.main.bounds.width)
////            make.bottom.equalTo(safeAreaLayoutGuide)
////            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(50)
//            make.edges.equalToSuperview()
//        }
        
        noDataView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(200)
            make.leading.equalToSuperview().inset(150)
            make.size.equalTo(100)
//            make.center.equalToSuperview()
        }
    }
}

extension TabBaseView {
    static func createThreeColumnSection() -> UICollectionViewLayout {
        let inset: CGFloat = 0.5
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}
