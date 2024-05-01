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
        
        let tableViewIndex = mainView.tableView.rx.willDisplayCell.asObservable()
        
        let input = HomeViewModel.Input(notificationEvent: notificationEvent, inputTableViewIndex: tableViewIndex)
        
        
        let output = viewModel.transform(input: input)
        
        output.postsDatas.drive(mainView.tableView.rx.items(cellIdentifier: HomeTableViewCell.identifier, cellType: HomeTableViewCell.self)) { [unowned self]
            index, item, cell in
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.configureCell(data: item, width: mainView.frame.width)
            cell.delegate = self
            
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

extension HomeViewController: CellDelegate {
    func commentButtonTap(vc: UIViewController) {
        let nav = UINavigationController(rootViewController: vc)

        navigationController?.present(nav, animated: true)
    }
    
    func profileViewTap(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}
