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
    
    override func configureNav() {
        super.configureNav()
        
        setNavigationBarTitleLabel()
    }
    
    override func bind() {
        let input = ChatListViewModel.Input(viewWillAppearTrigger: rx.viewWillAppear.map { _ in })
        
        let output = viewModel.transform(input: input)
        
//        let cellload = Observable.zip(mainView.tableView.rx.itemSelected, mainView.tableView.rx.modelSelected(ChatRoomsModel.self))
        
        output.chatListData.drive(mainView.tableView.rx.items(cellIdentifier: ChatListTableViewCell.identifier, cellType: ChatListTableViewCell.self)) { index, item, cell in
            
            if let image = item.participants[1].profileImage, image.isEmpty {
                cell.profileImageView.downloadImage(imageUrl: image)
            } else {
                cell.profileImageView.image = UIImage(systemName: "person")
            }
            
            cell.nickLabel.text = item.participants[1].nick
            
        }.disposed(by: disposeBag)
        
        mainView.tableView.rx.modelSelected(ChatRoomModel.self).bind(with: self) { owner, item in
            let chatVC = ChatViewController()
            
            chatVC.viewModel.roomId = item.roomId
            
            owner.navigationController?.pushViewController(chatVC, animated: true)
            
        }.disposed(by: disposeBag)
        
//        cellload.bind(with: self) { owner, item in
//            print("tap")
//        }.disposed(by: disposeBag)
        
//        cellload.map { item in
//            return (index: item.0, tableItem: item.1)
//        }.bind(with: self) { owner, cellInfo in
//            
//            let chatVC = ChatViewController()
//            
//            let id = cellInfo.tableItem.data[cellInfo.index.row].roomId
//            
//            print(id)
//            
//            chatVC.viewModel.roomId = id
//            
//            owner.navigationController?.pushViewController(chatVC, animated: true)
//            
//        }.disposed(by: disposeBag)
        
    }

}

extension ChatListViewController {
    func setNavigationBarTitleLabel() {
        let label = UILabel()
        
        label.text = "채팅"
        label.textColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
    }
}
