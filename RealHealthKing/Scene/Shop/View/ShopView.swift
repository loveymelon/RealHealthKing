//
//  ShopView.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/4/24.
//

import UIKit
import Then
import SnapKit

class ShopView: BaseView {
    
    let tableView = UITableView().then {
        $0.register(ShopTableViewCell.self, forCellReuseIdentifier: ShopTableViewCell.identifier)
        $0.estimatedRowHeight = 100
        $0.rowHeight = UITableView.automaticDimension
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
            make.edges.equalTo(safeAreaLayoutGuide.snp.edges)
        }
    }
}
