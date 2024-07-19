//
//  ChatViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/17/24.
//

import UIKit
import Then
import RxCocoa
import RxSwift

final class ChatViewController: BaseViewController<ChatView> {
    
    let viewModel = ChatViewModel()
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureNav() {
        super.configureNav()
        
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = "덤벨귀신"
    }
    
    override func bind() {
        
        let viewWillTrigger = rx.viewWillAppear.map { _ in }
        let viewDidAppearTrigger = rx.viewDidAppear.map { _ in }
        let viewDidDisappearTrigger = rx.viewDidDisappear.map { _ in }
        
        let sendButtonTap = mainView.chatTextView.userTextView.sendButton.rx.tap.withLatestFrom(mainView.chatTextView.userTextView.rx.text.orEmpty.asObservable())
        
        let input = ChatViewModel.Input(viewWillAppearTrigger: viewWillTrigger, viewDidAppearTrigger: viewDidAppearTrigger, viewDidDisappearTrigger: viewDidDisappearTrigger, sendButtonTap: sendButtonTap)

        let output = viewModel.transform(input: input)
        
        output.chatDatas.drive(mainView.tableView.rx.items(cellIdentifier: ChatTableViewCell.identifier, cellType: ChatTableViewCell.self)) { index, item, cell in
            
            cell.selectionStyle = .none
            cell.configureCell(model: item)
            
        }.disposed(by: disposeBag)
        
        output.chatCount.drive(with: self) { owner, count in
            let index = IndexPath(row: count-1, section: 0)
            
            owner.mainView.tableView.scrollToRow(at: index, at: .bottom, animated: false)
            
        }.disposed(by: disposeBag)
        
        mainView.chatTextView.userTextView.rx.didChange.subscribe(with: self) { owner, _ in
            
            let size = CGSize(width: owner.mainView.chatTextView.userTextView.bounds.width, height: .infinity)
            let estimated = owner.mainView.chatTextView.userTextView.sizeThatFits(size)
            
            let isMaxHeight = estimated.height >= 116
            
            guard isMaxHeight != owner.mainView.chatTextView.userTextView.isScrollEnabled else { return }
            
            owner.mainView.chatTextView.userTextView.isScrollEnabled = isMaxHeight
            owner.mainView.chatTextView.setNeedsUpdateConstraints()
            owner.mainView.chatTextView.reloadInputViews()
            
        }.disposed(by: disposeBag)

    }

}
