//
//  PhotoView.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/4/24.
//

import UIKit

final class PhotoView: UIView {
    
    let photoImageView = UIImageView(image: UIImage(systemName: "camera.fill")).then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
    }
    
    let countLabel = UILabel().then {
        $0.text = "0/5"
        $0.textAlignment = .center
        $0.textColor = .white
    }
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 0
        $0.distribution = .fillProportionally
//        $0.backgroundColor = .black
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PhotoView: UIConfigureProtocol {
    func configureUI() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        [photoImageView, countLabel].forEach { view in
            stackView.addArrangedSubview(view)
        }
        
        addSubview(stackView)
    }
    
    func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

        
    }
    
    
}
