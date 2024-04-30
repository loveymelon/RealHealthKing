//
//  HomeViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/22/24.
//

import UIKit
import Alamofire
import KeychainSwift

import RxSwift
import RxCocoa
import RxGesture

class HomeViewController: BaseViewController<HomeView> {
    
    let viewModel = HomeViewModel()
    
    let disposeBag = DisposeBag()
    
    let keyChain = KeychainSwift()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        let notificationEvent = Observable.merge([
            rx.viewWillAppear.take(1).map { _ in },
            NotificationCenterManager.like.addObserver().map { _ in  }
        ])
        
        let input = HomeViewModel.Input(notificationEvent: notificationEvent)
        
        let output = viewModel.transform(input: input)
        
        mainView.tableView.rx.willDisplayCell.bind { index in
            print(index.indexPath)
        }.disposed(by: disposeBag)
        
        output.postsDatas.drive(mainView.tableView.rx.items(cellIdentifier: HomeTableViewCell.identifier, cellType: HomeTableViewCell.self)) { [unowned self]
            index, item, cell in
            
//            let likeData = viewModel.a[index].likes.contains(keyChain.get("userId") ?? "empty")
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.configureCell(data: item, width: mainView.frame.width)
            
            cell.commentButton.rx.tap.map { _ in item.postId ?? "empty" }.bind(with: self) { owner, id in
                let vc = CommentViewController()
                
                vc.postId.accept(id)
                
                let nav = UINavigationController(rootViewController: vc)

                owner.present(nav, animated: true)
            }.disposed(by: disposeBag)
            
            // 여기서 재사용 이슈가 발생된다.
            cell.profileImageView.rx.tapGesture().when(.recognized).map { _ in item.creator.userId }.subscribe(with: self) { owner, id in
                let vc = ProfileViewController()
                
                if KeyChainManager.shared.userId == id {
                    vc.viewModel.viewState = .me
                } else {
                    vc.viewModel.otherUserId = id
                    vc.viewModel.viewState = .other
                }
                
                owner.navigationController?.pushViewController(vc, animated: true)
                
            }.disposed(by: disposeBag)
            
        }.disposed(by: disposeBag)
        
        mainView.tableView.rx.modelSelected(Posts.self).bind(with: self) { owner, item in
            let vc = DetailViewController()
            guard let postId = item.postId else { return }
            
            vc.postId.accept(postId)
            owner.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
    }

    override func configureNav() {
        navigationItem.largeTitleDisplayMode = .never
    }
}
