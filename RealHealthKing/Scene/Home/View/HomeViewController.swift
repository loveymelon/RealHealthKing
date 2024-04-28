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
        
        output.postsDatas.drive(mainView.tableView.rx.items(cellIdentifier: HomeTableViewCell.identifier, cellType: HomeTableViewCell.self)) { [unowned self]
            index, item, cell in
            
//            let likeData = viewModel.a[index].likes.contains(keyChain.get("userId") ?? "empty")
            print("index", index)
            cell.configureCell(data: item, width: mainView.frame.width)
            
        }.disposed(by: disposeBag)
        
        mainView.tableView.rx.modelSelected(Posts.self).bind(with: self) { owner, item in
            owner
        }.disposed(by: disposeBag)
    }

}
