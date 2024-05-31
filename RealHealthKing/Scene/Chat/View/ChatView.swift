//
//  ChatView.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/17/24.
//

import UIKit
import Then
import SnapKit

class ChatView: BaseView {
    
    let tableView = UITableView().then {
        $0.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identifier)
        $0.separatorStyle = .none
    }
    
    let chatTextView = ChatTextView().then {
        $0.backgroundColor = .black
        $0.isHidden = false
    }
    
    let noDataView = NoDataView().then {
        $0.setText("메세지를 시작해보세요")
        $0.backgroundColor = .black
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        addSubview(tableView)
        addSubview(chatTextView)
        addSubview(noDataView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        chatTextView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
            make.height.greaterThanOrEqualTo(54)
            make.height.lessThanOrEqualTo(120)
        }
        
        noDataView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
}
