//
//  ModifyView.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/27/24.
//

import UIKit
import Then
import SnapKit

final class ModifyView: BaseView {
    
    let profileImageView = UIImageView().then {
        $0.backgroundColor = .red
        $0.layer.cornerRadius = 100
    }
    let nickTextField = TextFieldView().then {
        $0.infoLabel.text = "닉네임"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        addSubview(profileImageView)
        addSubview(nickTextField)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide.snp.centerX)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(50)
            make.size.equalTo(200)
        }
        
        nickTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide.snp.horizontalEdges).inset(20)
            make.height.equalTo(48)
        }
    }
    
}
