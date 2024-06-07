//
//  ShopPostPhotoView.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/5/24.
//

import UIKit
import Then
import SnapKit

final class ShopPostPhotoView: UIView {
    
    let imageView = UIImageView().then {
        $0.image = UIImage(systemName: "person")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
    }
    
    let cancelButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        $0.tintColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ShopPostPhotoView: UIConfigureProtocol {
    func configureUI() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        addSubview(imageView)
        addSubview(cancelButton)
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(snp.edges)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.trailing.equalTo(snp.trailing).offset(8)
            make.top.equalTo(snp.top).offset(-8)
        }
    }
    
    
}
