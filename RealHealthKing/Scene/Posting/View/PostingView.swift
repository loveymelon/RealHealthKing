//
//  PostingView.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/18/24.
//

import UIKit
import Then
import SnapKit

final class PostingView: BaseView {
    
    let scrollView = UIScrollView().then {
        $0.isPagingEnabled = true
        $0.isScrollEnabled = true
    }
    
    let pageControl = UIPageControl().then {
        $0.pageIndicatorTintColor = .gray
        $0.currentPageIndicatorTintColor = .white
        $0.hidesForSinglePage = true
        $0.currentPage = 0
    }
    
    let imageNumberLabel = UILabel().then {
        $0.backgroundColor = .darkGray
        $0.layer.cornerRadius = 14
        $0.clipsToBounds = true
        $0.text = "0/1"
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
        $0.textColor = .white
    }
    
    let imageInfoLabel = UILabel().then {
        $0.text = "여기를 클릭하여 사진을 추가할 수 있습니다."
        $0.textColor = HKColor.text.color
        $0.textAlignment = .center
    }
    
    let tagTextFieldView = TextFieldView().then {
        $0.infoLabel.text = "태그"
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    let titleTextFieldView = TextFieldView().then {
        $0.infoLabel.text = "제목"
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    let memoTextView = UITextView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = HKColor.background.color
        $0.text = "본인의 내용을 작성해주세요"
        $0.font = .systemFont(ofSize: 15)
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    let saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(HKColor.text.color, for: .normal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        
        scrollView.addSubview(imageInfoLabel)
        addSubview(scrollView)
        addSubview(imageNumberLabel)
        addSubview(pageControl)
        
        [tagTextFieldView, titleTextFieldView].forEach { textField in
            stackView.addArrangedSubview(textField)
        }
        
        addSubview(stackView)
        addSubview(memoTextView)
    }
    
    override func configureLayout() {
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.5)
            make.width.equalTo(safeAreaLayoutGuide.snp.width)
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(scrollView.snp.bottom).inset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(30)
        }
        
        imageNumberLabel.snp.makeConstraints { make in
            make.top.trailing.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(30)
            make.width.equalTo(40)
        }
        
        imageInfoLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(30)
        }
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            make.top.equalTo(scrollView.snp.bottom).offset(15)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.15)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide.snp.horizontalEdges).inset(10)
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(10)
        }
    }
    
}
