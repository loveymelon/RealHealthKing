//
//  TextViewWithHelperView.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

class TextViewWithHelperView: UIView {

    let textFieldView = TextFieldView()
    
    let helperView = HelperView().then {
        $0.isHidden = true
    }
    
    let disposeBag = DisposeBag()
    
    let viewModel = TextWithHelperViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        let textFieldEndEdit = textFieldView.textField.rx.controlEvent(.editingDidEnd).withLatestFrom(textFieldView.textField.rx.text.orEmpty)
            .map { String($0) }
            .asObservable()
        
        let input = TextWithHelperViewModel.Input(textFieldEndEdit: textFieldEndEdit)
        
        let output = viewModel.transform(input: input)
        
        textFieldView.textField.rx.controlEvent(.editingDidBegin).bind(with: self) { owner, _ in
            owner.textFieldView.infoLabel.font = UIFont.systemFont(ofSize: 11)
            owner.textFieldView.infoLabelConstraint?.update(offset: -13)
        }.disposed(by: disposeBag)
        
        output.textInfoLayoutUpdate.drive(with: self) { owner, check in
            if !check {
                owner.textFieldView.infoLabel.font = UIFont.systemFont(ofSize: 18)
                owner.textFieldView.infoLabelConstraint?.update(offset: 0)
            }
        }.disposed(by: disposeBag)
    }
    
}

extension TextViewWithHelperView: UIConfigureProtocol {
    func configureUI() {
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        [textFieldView, helperView].forEach { view in
            addSubview(view)
        }
    }
    
    func configureLayout() {
        textFieldView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        
        helperView.snp.makeConstraints { make in
            make.top.equalTo(textFieldView.snp.bottom).offset(3)
            make.height.equalTo(textFieldView.snp.height).multipliedBy(0.3)
            make.leading.equalTo(textFieldView.snp.leading)
        }
    }
    
    
}
