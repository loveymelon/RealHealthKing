//
//  HelperView.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/14/24.
//

import UIKit
import Then
import SnapKit

final class HelperView: UIView {
    
    let imageView = UIImageView(image: UIImage(systemName: "exclamationmark.circle")).then {
        $0.tintColor = .red
    }
    
    let label = UILabel().then {
        $0.textColor = .red
        $0.font = .systemFont(ofSize: 14)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HelperView: UIConfigureProtocol {
    func configureUI() {
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        [imageView, label].forEach { view in
            addSubview(view)
        }
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.size.equalTo(20)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.top)
            make.leading.equalTo(imageView.snp.trailing).offset(5)
            make.height.equalTo(imageView.snp.height)
        }
    }
    
    
}
