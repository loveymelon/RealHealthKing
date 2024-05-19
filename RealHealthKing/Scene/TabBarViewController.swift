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
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        
        homeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        
        searchVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        
        let shopVC = UINavigationController(rootViewController: ShopViewController())
        
        shopVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "cart"), selectedImage: UIImage(systemName: "cart.fill"))
        
        let chatVC = UINavigationController(rootViewController: ChatListViewController())
        
        chatVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "message"), selectedImage: UIImage(systemName: "message"))
        
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        
        profileVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person"))
        
        viewControllers = [homeVC, shopVC, searchVC, chatVC, profileVC]
    }
}
