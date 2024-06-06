//
//  TabViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/11/24.
//

import UIKit
import Pageboy
import Tabman
import Then
import SnapKit

final class TabViewController: TabmanViewController {
    
    let baseView = UIView()

    private let normalVC = NormalPostViewController()
    private let marketVC = MarketPostViewController()
    
    var viewState: ScreenState = .me
    var userId = ""
    var closure: (() -> Void)?
    
    private lazy var vcs = [normalVC, marketVC]
    
//    private lazy var vcs = [NormalPostViewController(), MarketPostViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        
    }
    
}

extension TabViewController {
    private func configureUI() {
        configureHierarchy()
        configureLayout()
        configureBar()
        settingDatas()
        
        self.dataSource = self
        
    }
    
    private func configureHierarchy() {
        view.addSubview(baseView)
    }
    
    private func configureLayout() {
        baseView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.5)
        }
    }
    
    private func configureBar() {
        let bar = TMBar.TabBar()
        
        bar.layout.transitionStyle = .snap // Customize
        bar.layout.alignment = .centerDistributed
        bar.layout.contentInset = .init(top: 0, left: 0, bottom: 10, right: 0)
        
        bar.backgroundView.style = .clear
        
        bar.buttons.customize{
            (button)
            in
            button.tintColor = HKColor.assistant.color
            button.selectedTintColor = HKColor.text.color
        }
        
//        bar.indicator.weight = .custom(value: 3)
        bar.indicator.overscrollBehavior = .compress
        bar.indicator.tintColor = .clear
        
        addBar(bar, dataSource: self, at: .custom(view: baseView, layout: nil))
        
    }
    
    private func settingDatas() {
        normalVC.viewModel.viewState = self.viewState
        normalVC.viewModel.userId = self.userId
        
        marketVC.viewModel.viewState = self.viewState
        marketVC.viewModel.userId = self.userId
    }
    
}

extension TabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return vcs.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        
        let vc = vcs[index]
        
        if let normalVC = vc as? NormalPostViewController {
            normalVC.closure = {
                self.closure?()
            }
        }
        
        vc.mainView.collectionView.snp.makeConstraints { make in
            make.top.equalTo(barInsets.bottom).offset(50)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(vc.mainView.collectionView.collectionViewLayout.collectionViewContentSize.height)
            make.bottom.equalToSuperview()
        }
        
        vc.mainView.collectionView.backgroundColor = HKColor.background.color
        
        return vc
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        
        let item = TMBarItem(title: "")
        
        switch index {
        case 0:
            item.image = UIImage(systemName: "square.grid.3x3")
        default:
            item.image = UIImage(systemName: "cart")
        }
        
        return item
    }
}
