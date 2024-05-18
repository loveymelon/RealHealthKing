//
//  ChatViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/17/24.
//

import UIKit
import RxCocoa
import RxSwift

class ChatViewController: BaseViewController<ChatView> {
    
    let a = Observable.of([1,2,3])
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func bind() {
        a.bind(to: mainView.tableView.rx.items(cellIdentifier: ChatTableViewCell.identifier, cellType: ChatTableViewCell.self)) { index, item, cell in
            
            cell.state = .other
            
            cell.configureCell(text: "\(item) df,ahklsdfjklasdklgjklajslfhjkhdjkshvjkbcjkxbzkvbiuberwuibnikfahnks\ndfsjkahfjklsdaklfjklasdfjkldjsklfjsadklfjklsajfjkhljjk")
            
        }.disposed(by: disposeBag)
    }

}
