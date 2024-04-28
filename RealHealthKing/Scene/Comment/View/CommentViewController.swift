//
//  CommentViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/29/24.
//

import UIKit
import RxSwift
import RxCocoa

class CommentViewController: BaseViewController<CommentView> {
    
    let postId = BehaviorRelay(value: "")
    
    let viewModel = CommentViewModel()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bind() {
        let viewWill = rx.viewWillAppear.withLatestFrom(postId.asObservable())
        
        let input = CommentViewModel.Input(inputViewWillAppear: viewWill)
        
        let output = viewModel.transform(input: input)
        
        output.outputCommentData.drive(mainView.tableView.rx.items(cellIdentifier: CommentTableViewCell.identifier, cellType: CommentTableViewCell.self)) { index, item, cell in
            
            print(item)
            
        }.disposed(by: disposeBag)
    }

}
