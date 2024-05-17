//
//  ChatTableViewCell.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/17/24.
//

import UIKit
import Then
import SnapKit

class ChatTableViewCell: UITableViewCell {
    
    let messageBoxView = UITextView().then {
        $0.isScrollEnabled = false
        $0.isEditable = false
        $0.backgroundColor = .white
        $0.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        $0.layer.cornerRadius = 10
        $0.font = .systemFont(ofSize: 14)
        $0.sizeToFit()
    }
    
    let dateLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 12)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ChatTableViewCell: UIConfigureProtocol {
    func configureUI() {
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        contentView.addSubview(messageBoxView)
        contentView.addSubview(dateLabel)
    }
    
    func configureLayout() {
        messageBoxView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.greaterThanOrEqualTo(45)
            make.width.lessThanOrEqualTo(255)
            make.centerY.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(messageBoxView.snp.leading).offset(-5)
            make.bottom.equalTo(messageBoxView.snp.bottom)
        }
    }
    
    
}
