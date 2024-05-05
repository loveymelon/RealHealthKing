//
//  ShopTableViewCell.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/4/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import ImageIO
import iamport_ios

protocol PurchaseProtocol: AnyObject {
    func purchaseButtonTap(payment: IamportPayment)
}

final class ShopTableViewCell: UITableViewCell {
    
    let productImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.image = UIImage(systemName: "person")
    }
    let productLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .white
    }
    let productPriceLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 14)
    }
    
    var disposeBag = DisposeBag()
    
    weak var delegate: PurchaseProtocol?
    
    private let purchaseButton = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("구매하기", for: .normal)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
}

extension ShopTableViewCell: UIConfigureProtocol {
    func configureUI() {
        configureHierarchy()
        configureLayout()
        
        backgroundColor = .black
    }
    
    func configureHierarchy() {
        contentView.addSubview(productImageView)
        contentView.addSubview(productLabel)
        contentView.addSubview(productPriceLabel)
        contentView.addSubview(purchaseButton)
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
        
        purchaseButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).inset(5)
            make.bottom.equalTo(productImageView.snp.bottom)
        }
        
    }
}

extension ShopTableViewCell {
    func configureCell(data: Posts) {
        productLabel.text = data.title
        productPriceLabel.text = data.content1
        
        if let imageUrl = data.creator.profileImage {
            
            let url = APIKey.baseURL.rawValue + NetworkVersion.version.rawValue + "/" + imageUrl
            productImageView.downloadImage(imageUrl: url)
            
        } else {
            productImageView.image = UIImage(systemName: "person")
        }
        
        purchaseButton.rx.tap.withUnretained(self).subscribe { owner, _ in
            let price = data.content1?.extractNumbers(from: data.content1 ?? "0")
            let pgId = PG.html5_inicis.makePgRawName(pgId: "INIpayTest")
            
            let payment = IamportPayment(pg: pgId, merchant_uid: "ios_\(APIKey.secretKey.rawValue)_\(Int(Date().timeIntervalSince1970))", amount: price ?? "0").then {
                $0.pay_method = PayMethod.card.rawValue
                $0.name = owner.productLabel.text ?? "empty"
                $0.buyer_name = UserDefaults.standard.string(forKey: "nick") ?? "empty"
                $0.app_scheme = "king"
            }
            
            owner.delegate?.purchaseButtonTap(payment: payment)
        }.disposed(by: disposeBag)

    }
    
}
