//
//  ChatListViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/20/24.
//

import UIKit
import RxSwift
import RxCocoa

class ChatListViewController: BaseViewController<ChatListView> {
    
    let viewModel = ChatListViewModel()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bind() {
        let input = ChatListViewModel.Input(viewWillAppearTrigger: rx.viewWillAppear.map { _ in })
        
        let output = viewModel.transform(input: input)
        
        output.chatListData.drive(mainView.tableView.rx.items(cellIdentifier: ChatListTableViewCell.identifier, cellType: ChatListTableViewCell.self)) { index, item, cell in
            
            print(item)
            
            if let image = item.participants[0].profileImage, image.isEmpty {
                cell.profileImageView.downloadImage(imageUrl: image)
            } else {
                cell.profileImageView.image = UIImage(systemName: "person")
            }
            
            cell.nickLabel.text = item.participants[0].nick
            
            
            
        }.disposed(by: disposeBag)
    }

}
