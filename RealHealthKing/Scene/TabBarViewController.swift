//
//  TabBarViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/29/24.
//

import UIKit

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.barTintColor = .black
        tabBar.tintColor = .white
        addVC()
        
    }

}

extension TabBarViewController {
    private func addVC() {
        let homeVC = HomeViewController()
        
        homeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        let searchVC = SearchViewController()
        
        searchVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        
        let profileVC = ProfileViewController()
        
        profileVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person"))
        
        viewControllers = [homeVC, searchVC, profileVC]
    }
}
