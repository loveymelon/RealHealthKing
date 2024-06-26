//
//  ChatListViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/20/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ChatListViewController: BaseViewController<ChatListView> {
    
    private let viewModel = ChatListViewModel()
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureNav() {
        super.configureNav()
        
        setNavigationBarTitleLabel(title: "채팅목록")
    }
    
    override func bind() {
        let input = ChatListViewModel.Input(viewWillAppearTrigger: rx.viewWillAppear.map { _ in })
        
        let output = viewModel.transform(input: input)
        
        output.chatListData.drive(mainView.tableView.rx.items(cellIdentifier: ChatListTableViewCell.identifier, cellType: ChatListTableViewCell.self)) { index, item, cell in
            
            cell.configureCell(data: item)
            
        }.disposed(by: disposeBag)
        
        mainView.tableView.rx.modelSelected(ChatRoomModel.self).bind(with: self) { owner, item in
            
            let chatVC = ChatViewController()
            
            chatVC.viewModel.roomId = item.roomId
            
            owner.navigationController?.pushViewController(chatVC, animated: true)
            
        }.disposed(by: disposeBag)
        
    }

}
