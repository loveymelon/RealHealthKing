//
//  ChatListTableViewCell.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/20/24.
//

import UIKit
import Then
import SnapKit

class ChatListTableViewCell: UITableViewCell {
    
    let profileImageView = UIImageView()
    
    let nickLabel = UILabel()
    
    let contentLabel = UILabel()
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fillProportionally
        $0.spacing = 5
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ChatListTableViewCell: UIConfigureProtocol {
    func configureUI() {
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(stackView)
        
        [nickLabel, contentLabel].forEach { label in
            stackView.addArrangedSubview(label)
        }
    }
    
    func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.leading.equalTo(self.contentView.snp.leading).inset(10)
            make.centerY.equalTo(self.stackView.snp.centerY)
            make.size.equalTo(40)
        }
        
        nickLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
        }
        
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self.contentView).inset(10)
            make.leading.equalTo(self.profileImageView.snp.trailing).offset(10)
        }
    }
    
    
}
