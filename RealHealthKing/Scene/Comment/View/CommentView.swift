//
//  CommentView.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/29/24.
//

import UIKit
import SnapKit
import Then

final class CommentView: BaseView {

    let tableView = UITableView().then {
        $0.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        $0.backgroundColor = HKColor.background.color
        $0.rowHeight = 70
    }
    
    let commentTextView = UITextView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.backgroundColor = .clear
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 50)
        $0.isScrollEnabled = false
        $0.textColor = .white
    }
    
    let userImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 35 / 2
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 1
    }
    
    let doneButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        $0.backgroundColor = .blue
        $0.layer.cornerRadius = 13
        $0.tintColor = .white
    }
    
    let noDataView = NoDataView().then {
        $0.setText("댓글이 없습니다.")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        addSubview(userImageView)
        addSubview(commentTextView)
        addSubview(doneButton)
        addSubview(tableView)
        addSubview(noDataView)
    }
    
    override func configureLayout() {
        
        userImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.size.equalTo(35)
            make.centerY.equalTo(commentTextView.snp.centerY)
        }
        
        commentTextView.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(103.0)
            make.bottom.equalTo(keyboardLayoutGuide.snp.top)
            make.leading.equalTo(userImageView.snp.trailing).offset(5)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).inset(10)
        }
        
        doneButton.snp.makeConstraints { make in
            make.trailing.equalTo(commentTextView.snp.trailing).inset(5)
            make.bottom.equalTo(commentTextView.snp.bottom).inset(6)
            make.width.equalTo(40)
            make.height.equalTo(23)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(commentTextView.snp.top)
        }
        
        noDataView.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(100)
        }
        
        
    }
    
}
