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
        
        configureUI()
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
            make.leading.equalTo(contentView.snp.leading).inset(10)
            make.centerY.equalTo(contentView.snp.centerY)
            make.size.equalTo(40)
        }
        
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(10)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
    }
    
    
}

extension ChatListTableViewCell {
    func configureCell(data: ChatRoomModel) {
        if let image = data.participants[1].profileImage, image.isEmpty {
            profileImageView.downloadImage(imageUrl: image)
        } else {
            profileImageView.image = UIImage(systemName: "person")
        }
        print(data.participants[0].nick)
        nickLabel.text = data.participants[0].nick
        contentLabel.text = data.lastChat?.content
        
    }
}
