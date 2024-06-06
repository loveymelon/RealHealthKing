//
//  BaseController.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/12/24.
//

import UIKit

class BaseViewController<T: BaseView>: UIViewController {
    
    let mainView = T()
    
    override func loadView() {
        self.view = mainView
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNav()
        bind()
    }
    
    func configureNav() {
        
//        UINavigationBar.appearance().backgroundColor = .orange
        let navBarAppearance = UINavigationBarAppearance()
        // 객체 생성
        navBarAppearance.backgroundColor = HKColor.background.color
//        navBarAppearance.shadowColor = .clear
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        
        navigationController?.navigationBar.tintColor = .white
//        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func bind() {
        
    }

}
