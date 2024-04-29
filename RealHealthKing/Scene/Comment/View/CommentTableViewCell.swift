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
    }
    let commentLabel = UILabel().then {
        $0.textColor = .white
    }
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 0
        $0.distribution = .fillProportionally
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .red
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
        [nickLabel, commentLabel].forEach { label in
            stackView.addArrangedSubview(label)
        }
        contentView.addSubview(stackView)
    }
    
    func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.snp.leading).inset(10)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(profileImageView.snp.trailing).offset(30)
            make.height.equalTo(contentView.snp.height)
        }
    }
    
    
}


