//
//  TabViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/9/24.
//

import UIKit
import Tabman
import Pageboy

final class TabViewController: TabmanViewController {
    
    private let vcs = [TestAViewController(), TestBViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        
        
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap // Customize
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .fit
//        bar.layout.interButtonSpacing = view.bounds.width / 20
//        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        
        bar.backgroundView.style = .clear
//        bar.backgroundColor = .clear
        
        bar.buttons.customize{
            (button)
            in
            button.tintColor = .gray
            button.selectedTintColor = .white
//            button.font = UIFont.font(.robotoBold, ofSize: 14)
        }
        
        bar.indicator.weight = .custom(value: 3)
        bar.indicator.overscrollBehavior = .bounce
        bar.indicator.tintColor = .white
        
        // Add to view
        addBar(bar, dataSource: self, at: .top)
        
        
    }
    

}

extension TabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return vcs.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return vcs[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {

        let item = TMBarItem(title: "")
        
        guard let image = UIImage(systemName: "star.fill") else { return TMBarItem(title: "dfdasfads") }
        
        item.image = image.withTintColor(.red)
        item.selectedImage = UIImage(systemName: "star.fill")
//        item.image?.withTintColor(.gray)
        item.selectedImage?.withTintColor(.white)
        
        return item
    }
}
