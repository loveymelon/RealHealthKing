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

class ChatViewController: BaseViewController<ChatView> {
    
//    var chatModel = ChatModel()
    let roomId = PublishRelay<String>()
    
    let viewModel = ChatViewModel()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func bind() {
        
        let viewWillTrigger = rx.viewWillAppear.withLatestFrom(roomId)
        
        let input = ChatViewModel.Input(viewWillAppearTrigger: viewWillTrigger)

        let output = viewModel.transform(input: input)
        
        output.chatDatas.drive(mainView.tableView.rx.items(cellIdentifier: ChatTableViewCell.identifier, cellType: ChatTableViewCell.self)) { index, item, cell in
            
            cell.state = item.isUser ? .me : .other
            
            cell.configureCell(text: item.textContent)
            
        }.disposed(by: disposeBag)
        
        mainView.chatTextView.userTextView.rx.didChange.subscribe(with: self) { owner, _ in
            
            let size = CGSize(width: owner.mainView.chatTextView.userTextView.bounds.width, height: .infinity)
            let estimated = owner.mainView.chatTextView.userTextView.sizeThatFits(size)
            
            let isMaxHeight = estimated.height >= 113
            
            print("contentSize", owner.mainView.chatTextView.userTextView.contentSize.height, owner.mainView.chatTextView.userTextView.frame.height)
            
            guard isMaxHeight != owner.mainView.chatTextView.userTextView.isScrollEnabled else { return }
            
            owner.mainView.chatTextView.userTextView.isScrollEnabled = isMaxHeight
            owner.mainView.chatTextView.setNeedsUpdateConstraints()
            owner.mainView.chatTextView.reloadInputViews()
            
            print("height", estimated.height)
            
        }.disposed(by: disposeBag)
    }

}
