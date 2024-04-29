//
//  DetailView.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/29/24.
//

import UIKit

class DetailView: BaseView {

    let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "person")
        $0.tintColor = .blue
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white.cgColor
    }
    
    let nickNameLabel = InfoLabel().then {
        $0.text = "fdsafdasfasf"
    }
    
    let topStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.spacing = 10
        $0.alignment = .fill
    }
    
    let scrollView = UIScrollView().then {
        $0.isPagingEnabled = true
        $0.isScrollEnabled = true
    }
    
    let pageControl = UIPageControl().then {
        $0.pageIndicatorTintColor = .gray
        $0.currentPageIndicatorTintColor = .white
        $0.hidesForSinglePage = true
        $0.currentPage = 0
    }
    
    let likeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "heart"), for: .normal)
        $0.setImage(UIImage(systemName: "heart.fill"), for: .selected)
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
    
    let contentLabel = UILabel().then {
        $0.numberOfLines = 3
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 20)
    }
    
    let moreButton = UIButton().then {
        $0.setTitle("더보기", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        [profileImageView, nickNameLabel].forEach { view in
            topStackView.addArrangedSubview(view)
        }
        
        addSubview(topStackView)
        addSubview(scrollView)
        
        [likeButton, commentButton].forEach { button in
            bottomStackView.addArrangedSubview(button)
        }
        
        addSubview(bottomStackView)
        addSubview(pageControl)
        addSubview(contentLabel)
    }
    
    override func configureLayout() {
        topStackView.snp.makeConstraints { make in
            make.top.leading.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(40)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(topStackView.snp.height)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.height.equalTo(profileImageView)
        }
        
        scrollView.snp.makeConstraints { make in
            make.width.equalTo(safeAreaLayoutGuide.snp.width)
            make.top.equalTo(topStackView.snp.bottom).offset(10)
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
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            make.top.equalTo(bottomStackView.snp.bottom).offset(10)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}