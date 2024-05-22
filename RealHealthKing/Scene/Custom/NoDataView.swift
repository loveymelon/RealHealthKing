//
//  NoDataView.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/2/24.
//

import UIKit
import Then
import SnapKit

final class NoDataView: UIView {
    
    private let noDataLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 20)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ str: String) {
        noDataLabel.text = str
    }
    
}

extension NoDataView: UIConfigureProtocol {
    func configureUI() {
        configureHierarchy()
        configureLayout()
        
        backgroundColor = .clear
        isHidden = true
    }
    
    func configureHierarchy() {
        addSubview(noDataLabel)
    }
    
    func configureLayout() {
        noDataLabel.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
        }
    }
    
    
}
