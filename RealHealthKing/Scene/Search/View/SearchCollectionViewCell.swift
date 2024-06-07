//
//  SearchCollectionViewCell.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/25/24.
//

import UIKit
import SnapKit
import Then

final class SearchCollectionViewCell: UICollectionViewCell {
    let postImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        print(#function)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SearchCollectionViewCell: UIConfigureProtocol {
    func configureUI() {
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        contentView.addSubview(postImageView)
    }
    
    func configureLayout() {
        postImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.snp.edges)
        }
    }
}
