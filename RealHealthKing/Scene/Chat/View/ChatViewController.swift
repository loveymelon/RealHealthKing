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
    
    let a = Observable.of([1,2,3])
    var chatModel = ChatModel()
    
    let viewModel = ChatViewModel()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func bind() {
        
        let viewWillTrigger = rx.viewWillAppear.withUnretained(self).map { owner, _ in
            return owner.chatModel
        }
        
        let input = ChatViewModel.Input(viewWillAppearTrigger: viewWillTrigger)
        
        _ = viewModel.transform(input: input)
        
        a.bind(to: mainView.tableView.rx.items(cellIdentifier: ChatTableViewCell.identifier, cellType: ChatTableViewCell.self)) { index, item, cell in
            
            cell.state = .other
            
            cell.configureCell(text: "\(item) df,ahklsdfjklasdklgjklajslfhjkhdjkshvjkbcjkxbzkvbiuberwuibnikfahnks\ndfsjkahfjklsdaklfjklasdfjkldjsklfjsadklfjklsajfjkhljjk")
            
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
