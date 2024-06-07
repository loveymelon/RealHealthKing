//
//  LauchScreenView.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/28/24.
//

import UIKit
import Then
import SnapKit
import Lottie

final class LauchScreenView: BaseView {
    
    let animationView: LottieAnimationView = LottieAnimationView(name: "HKLoading")

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        addSubview(animationView)
    }
    
    override func configureLayout() {
        animationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
