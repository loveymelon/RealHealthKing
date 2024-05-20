//
//  ChatListView.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/20/24.
//

import UIKit
import SnapKit
import Then

class ChatListView: BaseView {
    
    let tableView = UITableView().then {
        $0.register(ChatListTableViewCell.self, forCellReuseIdentifier: ChatListTableViewCell.identifier)
        $0.rowHeight = 50
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
}
