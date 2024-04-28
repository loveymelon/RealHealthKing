//
//  CommentView.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/29/24.
//

import UIKit
import SnapKit
import Then

class CommentView: BaseView {

    let tableView = UITableView().then {
        $0.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        $0.backgroundColor = .black
    }
    let commentTextView = UITextView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        addSubview(tableView)
        addSubview(commentTextView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.9)
        }
        
        commentTextView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
}
