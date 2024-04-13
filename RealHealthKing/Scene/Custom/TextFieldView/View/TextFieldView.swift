//
//  TextFieldView.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/13/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class TextFieldView: UIView, UIConfigureProtocol {
    
    let textField = CustomTextField()
    let infoLabel = InfoLabel()
    let secureButton = UIButton().then {
        $0.setTitle("표시", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        $0.isEnabled = false
        $0.isHidden = true
    }
    
    var infoLabelConstraint: Constraint?
    
    let viewModel = TextFieldViewModel()
    let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        let textFieldEndEdit = textField.rx.controlEvent(.editingDidEnd).withLatestFrom(textField.rx.text.orEmpty)
            .map { String($0) }
            .asObservable()
        
        let input = TextFieldViewModel.Input(textFieldEndEdit: textFieldEndEdit)
        
        let output = viewModel.transform(input: input)
        
        textField.rx.controlEvent(.editingDidBegin).bind(with: self) { owner, _ in
            owner.infoLabel.font = UIFont.systemFont(ofSize: 11)
            owner.infoLabelConstraint?.update(offset: -13)
        }.disposed(by: disposeBag)
        
        secureButton.rx.tap.bind(with: self) { owner, _ in
            owner.textField.isSecureTextEntry.toggle()
        }.disposed(by: disposeBag)
        
        output.textInfoLayoutUpdate.drive(with: self) { owner, check in
            if !check {
                owner.infoLabel.font = UIFont.systemFont(ofSize: 18)
                owner.infoLabelConstraint?.update(offset: 0)
            }
        }.disposed(by: disposeBag)
        
    }
    
    func configureUI() {
        backgroundColor = .darkGray
        clipsToBounds = true
        layer.cornerRadius = 10
        
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        [textField, infoLabel, secureButton].forEach { item in
            addSubview(item)
        }
    }
    
    func configureLayout() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(snp.top).inset(15)
            make.bottom.equalTo(snp.bottom).inset(2)
            make.horizontalEdges.equalTo(snp.horizontalEdges).inset(8)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(snp.horizontalEdges).inset(8)
            infoLabelConstraint = make.centerY.equalTo(snp.centerY).constraint
        }
        
        secureButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(snp.verticalEdges).inset(15)
            make.trailing.equalTo(snp.trailing).inset(8)
        }
    }
    
}
