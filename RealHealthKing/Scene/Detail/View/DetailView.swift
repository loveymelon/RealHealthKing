//
//  DetailView.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/29/24.
//

import UIKit
import Then
import SnapKit

final class DetailView: BaseView {
    
    let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleToFill
        $0.image = UIImage(systemName: "person")
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white.cgColor
    }
    
    let nickNameLabel = InfoLabel()
    
    let scrollView = UIScrollView().then {
        $0.isPagingEnabled = true
        $0.isScrollEnabled = true
    }
    
    let pageControl = UIPageControl().then {
        $0.pageIndicatorTintColor = .gray
        $0.currentPageIndicatorTintColor = HKColor.point.color
        $0.hidesForSinglePage = true
        $0.currentPage = 0
    }
    
    let likeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "heart"), for: .normal)
        $0.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        $0.tintColor = .red
    }
    
    let commentButton = UIButton().then {
        $0.setImage(UIImage(systemName: "message"), for: .normal)
    }
    
    let bottomStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = 10
        $0.alignment = .fill
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = HKColor.text.color
    }
    
    let contentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = HKColor.text.color
        $0.font = .systemFont(ofSize: 20)
    }
    
    let hashLabel = UILabel().then {
        $0.textColor = .systemBlue
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        
        [profileImageView, nickNameLabel, scrollView, bottomStackView, pageControl, contentLabel, hashLabel].forEach { view in
            addSubview(view)
        }
        
        [likeButton, commentButton].forEach { button in
            bottomStackView.addArrangedSubview(button)
        }

    }
    
    override func configureLayout() {
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.top.leading.equalTo(safeAreaLayoutGuide).inset(10)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.height.equalTo(profileImageView)
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.leading.equalTo(profileImageView.safeAreaLayoutGuide.snp.trailing).offset(10)
        }
        
        scrollView.snp.makeConstraints { make in
            make.width.equalTo(safeAreaLayoutGuide.snp.width)
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.4)
        }
        
        bottomStackView.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).inset(5)
            make.top.equalTo(scrollView.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide.snp.centerX)
            make.centerY.equalTo(bottomStackView.snp.centerY)
            make.height.equalTo(20)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.top.equalTo(bottomStackView.snp.bottom).offset(30)
//            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        hashLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.leading.equalTo(contentLabel.snp.leading)
        }
    }
}
