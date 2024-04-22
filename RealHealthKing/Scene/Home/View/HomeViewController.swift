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

class HomeViewController: BaseViewController<HomeView>{
    
    var postData: [Posts]?
    
    let viewDidLoadTrigger = BehaviorRelay<Void>(value: ())
    
    let viewModel = HomeViewModel()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewDidLoadTrigger.accept(())
        
    }
    
    override func bind() {
        let input = HomeViewModel.Input(viewDidLoadTrigger: viewDidLoadTrigger.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.postsDatas.drive(mainView.tableView.rx.items(cellIdentifier: HomeTableViewCell.identifier, cellType: HomeTableViewCell.self)) { [unowned self]
            index, item, cell in
            print(mainView.frame.width)
            cell.configureCell(data: item, width: mainView.frame.width)
        }.disposed(by: disposeBag)
    }

}
