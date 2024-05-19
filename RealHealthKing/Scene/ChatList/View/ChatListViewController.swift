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
        
        
    }

}
