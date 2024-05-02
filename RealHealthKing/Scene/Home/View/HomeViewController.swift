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
    let homeModel = HomeModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        
        let viewWillAppearTrigger = rx.viewWillAppear.map { _ in }
        
        let tableViewIndex = mainView.tableView.rx.willDisplayCell.asObservable()
        
        let input = HomeViewModel.Input(inputViewWillTirgger: viewWillAppearTrigger, inputTableViewIndex: tableViewIndex)
        
        let output = viewModel.transform(input: input)
        
        output.postsDatas.drive(mainView.tableView.rx.items(cellIdentifier: HomeTableViewCell.identifier, cellType: HomeTableViewCell.self)) { [unowned self]
            index, item, cell in
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.configureCell(data: item, width: mainView.frame.width, homeModel: homeModel, index: index)
            cell.delegate = self
            
            
        }.disposed(by: disposeBag)
        
        output.outputNoData.drive(with: self) { owner, isValid in
            owner.mainView.noDataView.isHidden = !isValid
            owner.mainView.tableView.isHidden = isValid
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
