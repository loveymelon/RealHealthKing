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
        $0.layer.borderColor = UIColor.white.cgColor
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 40
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
    
    let leftButton = UIButton().then {
        $0.setTitle("프로필 수정", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .darkGray
        $0.layer.cornerRadius = 10
    }
    
    let rightBarButton = UIButton().then {
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
    }
    
    let containerView = UIView()
    
    
    let scrollView = UIScrollView()
    
    let contentView = UIView()
    
    let tabVC = TabViewController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(postView)
        contentView.addSubview(followingView)
        contentView.addSubview(follwerView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(leftButton)
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(tabVC.view)
        
        
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(scrollView.safeAreaLayoutGuide)
            make.width.equalTo(scrollView.safeAreaLayoutGuide.snp.width)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.leading.equalTo(contentView.safeAreaLayoutGuide.snp.leading).inset(30)
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).inset(10)
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
        
        leftButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            make.leading.equalTo(nicknameLabel.snp.leading)
            make.trailing.equalTo(follwerView.snp.trailing)
//            make.bottom.equalTo(contentView.snp.bottom).offset(-500)
            make.height.equalTo(26)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(leftButton.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).offset(-300)
        }
        
    }
    
    
}
