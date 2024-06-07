//
//  ShopPostView.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/4/24.
//

import UIKit
import SnapKit
import Then

class ShopPostView: BaseView {
    
    let vScrollView = UIScrollView().then {
        $0.isScrollEnabled = true
        $0.bounces = false
    }
    
    let hScrollView = UIScrollView().then {
        $0.isScrollEnabled = true
        $0.bounces = false
    }
    
    let hStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.spacing = 10
    }
    
    let photoView = PhotoView().then {
        $0.backgroundColor = .black
    }
    
    let titleLabel = UILabel().then {
        $0.text = "상품명"
        $0.textColor = HKColor.text.color
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    let titleTextField = UITextField().then {
        $0.setPlaceholder(string: "상품명 입력해주세요.", color: .gray)
        $0.addLeftPadding()
        $0.textColor = HKColor.text.color
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 3
    }
    
    let priceLabel = UILabel().then {
        $0.text = "가격"
        $0.textColor = HKColor.text.color
        $0.font = .boldSystemFont(ofSize: 16)
    }

    let priceTextField = UITextField().then {
        $0.setPlaceholder(string: "₩ 가격을 입력해주세요.", color: .gray)
        $0.addLeftPadding()
        $0.tintColor = .white
        $0.textColor = .white
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 3
        $0.keyboardType = .numberPad
        $0.setClearButton(with: UIImage(systemName: "xmark.circle.fill")!, mode: .always)
        $0.rightViewMode = .whileEditing
        $0.rightViewRect(forBounds: CGRect(x: -10, y: 0, width: 10, height: 10))
        
    }
    
    let clearButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        $0.contentMode = .scaleAspectFit
    }
    
    let detailLabel = UILabel().then {
        $0.text = "자세한 설명"
        $0.textColor = HKColor.text.color
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    let detailTextView = UITextView().then {
        $0.text = "상품에 대한 설명을 자세하게 적어주세요."
        $0.textColor = HKColor.text.color
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 3
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 50)
        $0.backgroundColor = .clear
    }
    
    let saveButton = UIButton().then {
        $0.setTitle("작성 완료", for: .normal)
//        $0.backgroundColor = HKColor.assistant.color
        $0.setTitleColor(HKColor.text.color, for: .normal)
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = HKColor.text.color.cgColor
        $0.layer.borderWidth = 1
    }
    
    let vContentView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        addSubview(vScrollView)
        vScrollView.addSubview(vContentView)
        
        
        vContentView.addSubview(hScrollView)
        hScrollView.addSubview(hStackView)
        
        [photoView].forEach { view in
            
            hStackView.addArrangedSubview(view)
        }

        
        [titleLabel, titleTextField, priceLabel, priceTextField, detailLabel, detailTextView].forEach { view in
            vContentView.addSubview(view)
        }
        
        addSubview(saveButton)
    }
    
    override func configureLayout() {
        vScrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        vContentView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(vScrollView)
            make.width.equalTo(vScrollView.snp.width)
        }
        
        hScrollView.snp.makeConstraints { make in
            make.top.equalTo(vContentView.snp.top)
            make.width.equalTo(snp.width)
            make.height.equalTo(100)
        }
        
        hStackView.snp.makeConstraints { make in
            make.height.equalTo(hScrollView.snp.height)
            make.leading.equalTo(hScrollView.snp.leading).inset(20)
//            make.width.equalTo(hScrollView.snp.width).multipliedBy(1.5)
            make.verticalEdges.trailing.equalTo(hScrollView)
        }
        
        [photoView].forEach { photoView in
            photoView.snp.makeConstraints { make in
                make.size.equalTo(70)
                
            }
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(vContentView).inset(20)
            make.top.equalTo(hStackView.snp.bottom).offset(30)
            make.height.equalTo(40)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.height.equalTo(50)
            make.horizontalEdges.equalTo(vContentView).inset(20)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleTextField.snp.bottom).offset(30)
            make.height.equalTo(40)
        }
        
        priceTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(vContentView).inset(20)
            make.height.equalTo(50)
            make.top.equalTo(priceLabel.snp.bottom).offset(5)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(priceTextField.snp.bottom).offset(30)
            make.height.equalTo(30)
        }
        
        detailTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(vContentView.snp.horizontalEdges).inset(20)
            make.top.equalTo(detailLabel.snp.bottom).offset(5)
            make.bottom.equalTo(vContentView.snp.bottom).offset(-300)
            make.height.greaterThanOrEqualTo(120)
        }
        
        saveButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide.snp.horizontalEdges).inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(10)
            make.height.equalTo(40)
        }
        
    }
    
}
