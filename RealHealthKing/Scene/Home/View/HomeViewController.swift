//
//  HomeViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/22/24.
//

import UIKit

class HomeViewController: BaseViewController<HomeView>{

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.scrollView.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateImageViews(imageCount: 5)
        print(mainView.contentLabel.lineCount)
    }

}

extension HomeViewController {
    private func updateImageViews(imageCount: Int) {
        
        for num in 0..<imageCount {
            let imageView = UIImageView()
            let postionX = mainView.frame.width * CGFloat(num)
            imageView.frame = CGRect(x: postionX, y: 0, width: mainView.frame.width, height: mainView.scrollView.bounds.height)
            
            imageView.image = UIImage(systemName: "star.fill")
            imageView.backgroundColor = .red
            mainView.scrollView.addSubview(imageView)
            
            mainView.scrollView.contentSize.width = mainView.frame.width * CGFloat(1+num) // scrollView의 넓이 설정
        }
        
        mainView.pageControl.numberOfPages = imageCount
        
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        mainView.pageControl.currentPage = Int(round(mainView.scrollView.contentOffset.x / UIScreen.main.bounds.width))
    }
}
