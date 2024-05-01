//
//  ProfileView.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/25/24.
//

import UIKit
import Then
import SnapKit

class ProfileView: BaseView {
    
    let profileImageView = UIImageView(image: UIImage(systemName: "person")).then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.red.cgColor
        $0.clipsToBounds = true
    }
    
    let postView = CountView().then {
        $0.titleLabel.text = "게시물"
    }
    
    let follwerView = CountView().then {
        $0.titleLabel.text = "팔로워"
    }
    
    let followingView = CountView().then {
        $0.titleLabel.text = "팔로잉"
    }
    
    let nicknameLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    let rightBarButton = UIButton().then {
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
    }
    
    let leftButton = UIButton().then {
        $0.setTitle("프로필 수정", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .darkGray
        $0.layer.cornerRadius = 10
    }
    
    let rightButton = UIButton().then {
        $0.setTitle("프로필 수정", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .darkGray
    }
    
    let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 4
        $0.alignment = .fill
    }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createThreeColumnSection()).then {
        $0.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        $0.isScrollEnabled = false
        $0.backgroundColor = .black
    }
    
    let lineView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let scrollView = UIScrollView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        }
    }
    
    override func configureHierarchy() {
        [leftButton, rightButton].forEach { button in
            buttonStackView.addArrangedSubview(button)
        }
        
        addSubview(scrollView)
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(postView)
        scrollView.addSubview(followingView)
        scrollView.addSubview(follwerView)
        scrollView.addSubview(nicknameLabel)
        scrollView.addSubview(buttonStackView)
        scrollView.addSubview(lineView)
        scrollView.addSubview(collectionView)
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.leading.equalToSuperview().inset(30)
            make.top.equalToSuperview().inset(10)
        }
        
        postView.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.centerY.equalTo(profileImageView.snp.centerY).offset(-10)
            make.size.equalTo(profileImageView)
        }
        
        followingView.snp.makeConstraints { make in
            make.leading.equalTo(postView.snp.trailing)
            make.centerY.equalTo(postView.snp.centerY)
            make.size.equalTo(postView)
        }
        
        follwerView.snp.makeConstraints { make in
            make.leading.equalTo(followingView.snp.trailing)
            make.centerY.equalTo(postView.snp.centerY)
            make.size.equalTo(postView)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.leading.equalTo(profileImageView.snp.leading)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.leading)
            make.height.equalTo(26)
            make.trailing.equalTo(follwerView.snp.trailing)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(10)
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(1)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(500)
        }
    }
    
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
