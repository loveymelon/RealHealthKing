//
//  CommentTableViewCell.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/29/24.
//

import UIKit
import SnapKit
import Then

class CommentTableViewCell: UITableViewCell {
    
    let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.cornerRadius = 20
    }
    let nickLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "fdfdfd"
        $0.font = .boldSystemFont(ofSize: 16)
        
    }
    let commentLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "fdfdfdfdfdfdsafd"
        $0.font = .systemFont(ofSize: 12)
        $0.numberOfLines = 0
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CommentTableViewCell: UIConfigureProtocol {
    func configureUI() {
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nickLabel)
        contentView.addSubview(commentLabel)
    }
    
    func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.snp.leading).inset(10)
        }
        
        nickLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top)
            make.height.equalToSuperview().multipliedBy(0.2)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(nickLabel.snp.bottom)
            make.leading.equalTo(nickLabel.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing).inset(10)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    
}


