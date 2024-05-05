//
//  PurchaseView.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/5/24.
//

import Foundation
import WebKit
import Then
import SnapKit

class PurchaseView: BaseView {
    
    let webView = WKWebView().then {
        $0.backgroundColor = .white
    }
    let indicator = UIActivityIndicatorView().then {
        $0.isHidden = true
        $0.color = .red
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        addSubview(webView)
        addSubview(indicator)
    }
    
    override func configureLayout() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        indicator.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(webView)
        }
    }
    
}
