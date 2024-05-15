//
//  HomeViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/22/24.
//

import UIKit
import Alamofire

import RxSwift
import RxCocoa
import RxGesture

class HomeViewController: BaseViewController<HomeView> {
    
    let viewModel = HomeViewModel()
    
    let disposeBag = DisposeBag()
    
    private let homeModel = HomeModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        
        let viewWillAppearTrigger = rx.viewWillAppear.map { _ in }
        
        let tableViewIndex = mainView.tableView.rx.willDisplayCell.asObservable()
        
        let input = HomeViewModel.Input(inputViewWillTirgger: viewWillAppearTrigger, inputTableViewIndex: tableViewIndex)
        
        let output = viewModel.transform(input: input)
        
        output.postsDatas.drive(mainView.tableView.rx.items(cellIdentifier: HomeTableViewCell.identifier, cellType: HomeTableViewCell.self)) { [weak self]
            index, item, cell in
            
            guard let self else { return }
            
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
        
        mainView.plusButton.rx.tap.bind(with: self) { owner, _ in
            owner.navigationController?.pushViewController(PostingViewController(), animated: true)
        }.disposed(by: disposeBag)
    }

    override func configureNav() {
        super.configureNav()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: mainView.plusButton)
    }
}

extension HomeViewController: CellDelegate {
    func moreButtonTap() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            mainView.tableView.reloadData()
        }
    }
    
    func commentButtonTap(vc: UIViewController) {
        let nav = UINavigationController(rootViewController: vc)

        navigationController?.present(nav, animated: true)
    }
    
    func profileViewTap(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}
