//
//  MarketView.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/15/24.
//

import UIKit
import Then
import SnapKit

final class MarketView: BaseView {
    
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
    
    let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleToFill
        $0.image = UIImage(systemName: "person")
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white.cgColor
    }
    
    let nickLabel = UILabel().then {
        $0.textColor = HKColor.text.color
        $0.font = .systemFont(ofSize: 18)
    }
    
    let lineView = UIView().then {
        $0.backgroundColor = .gray
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = HKColor.text.color
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    let commentLabel = UILabel().then {
        $0.textColor = HKColor.text.color
        $0.font = .systemFont(ofSize: 16)
    }
    
    let bottomView = UIView().then {
        $0.backgroundColor = HKColor.background.color
    }
    
    let chatButton = UIButton().then {
        $0.setImage(UIImage(systemName: "message"), for: .normal)
        $0.layer.cornerRadius = 5
    }
    
    let purchaseButton = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("구매하기", for: .normal)
        $0.layer.cornerRadius = 5
    }
    
    let priceLabel = UILabel().then {
        $0.textColor = HKColor.text.color
        $0.font = .systemFont(ofSize: 18)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        [scrollView, pageControl, profileImageView, nickLabel, lineView, titleLabel, commentLabel, bottomView].forEach { view in
            addSubview(view)
        }
        
        [priceLabel, purchaseButton, chatButton].forEach { view in
            bottomView.addSubview(view)
        }
        
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.width.equalTo(snp.width)
            make.top.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.5)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalTo(scrollView.snp.centerX)
            make.bottom.equalTo(scrollView.snp.bottom).inset(10)
            make.height.equalTo(20)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
            make.size.equalTo(40)
        }
        
        nickLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.centerY.equalTo(profileImageView.snp.centerY)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.height.equalTo(1)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        bottomView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(30)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
        
        purchaseButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
            make.height.equalTo(26)
        }
        
        chatButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(purchaseButton.snp.leading).offset(-20)
            make.height.equalTo(26)
        }
        
    }
    
}
