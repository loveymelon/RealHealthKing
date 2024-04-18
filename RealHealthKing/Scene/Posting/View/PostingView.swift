//
//  PostingView.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/18/24.
//

import UIKit
import Then
import SnapKit

class PostingView: BaseView {
    
    let imageView = UIImageView(image: UIImage(systemName: "plus")).then {
        $0.isUserInteractionEnabled = true
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
    } // tapGesture 추가
    
    let tagTextFieldView = TextFieldView().then {
        $0.infoLabel.text = "태그"
    }
    
    let titleTextFieldView = TextFieldView().then {
        $0.infoLabel.text = "제목"
    }
    
    let memoTextView = UITextView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
