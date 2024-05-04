//
//  ShopTableViewCell.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/4/24.
//

import UIKit
import Then
import SnapKit

final class ShopTableViewCell: UITableViewCell {
    
    let productImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .red
        $0.image = UIImage(systemName: "person")
    }
    let productLabel = UILabel().then {
        $0.text = "55555"
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .black
        $0.backgroundColor = .red
    }
    let productPriceLabel = UILabel().then {
        $0.text = "44444"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 14)
    }
    let buyButton = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("구매하기", for: .normal)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .blue
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ShopTableViewCell: UIConfigureProtocol {
    func configureUI() {
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        contentView.addSubview(productImageView)
        contentView.addSubview(productLabel)
        contentView.addSubview(productPriceLabel)
        contentView.addSubview(buyButton)
    }
    
    func configureLayout() {
        
        productImageView.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.leading.equalTo(contentView.snp.leading).inset(10)
            make.verticalEdges.equalToSuperview().inset(10)
        }
        productLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.top)
            make.leading.equalTo(productImageView.snp.trailing).offset(10)
        }
        
        productPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(productLabel.snp.bottom).offset(5)
            make.leading.equalTo(productLabel.snp.leading)
        }
        
        buyButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).inset(5)
            make.bottom.equalTo(productImageView.snp.bottom)
        }
        
    }
}
