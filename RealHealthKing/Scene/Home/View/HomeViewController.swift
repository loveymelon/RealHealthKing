//
//  HomeViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/22/24.
//

import UIKit
import Alamofire
import KeychainSwift

class HomeViewController: BaseViewController<HomeView>{
    
    var postData: [Posts]?

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.scrollView.delegate = self
        NetworkManager.fetchPosts { result in
            switch result {
            case .success(let data):
                self.postData = data
                print(data)
                self.updateImageViews(postData: data[0].files)
            case .failure(let failure):
                print(failure.description)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        // data.files로 파일의 경로를 받으면 다시 그거가지고 파일 수만큼 통신후 그 값을 이미지로 넣는다
//        print(mainView.contentLabel.lineCount)
    }

}

extension HomeViewController {
    private func updateImageViews(postData: [String]) {
        
        for num in 0..<postData.count {
            let imageView = UIImageView()
            let postionX = mainView.frame.width * CGFloat(num)
            
            let width = mainView.frame.width
            let height = mainView.scrollView.bounds.height
            
            imageView.frame = CGRect(x: postionX, y: 0, width: width, height: height)
            
            let url = APIKey.baseURL.rawValue + NetworkVersion.version.rawValue + "/" + postData[num]
            
            imageView.downloadImage(imageUrl: url, width: width, height: height)
            
//            imageView.image = UIImage(systemName: "star.fill")
//            imageView.backgroundColor = .red
            mainView.scrollView.addSubview(imageView)
            
            mainView.scrollView.contentSize.width = mainView.frame.width * CGFloat(1+num) // scrollView의 넓이 설정
        }
        
        mainView.pageControl.numberOfPages = postData.count
        
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        mainView.pageControl.currentPage = Int(round(mainView.scrollView.contentOffset.x / UIScreen.main.bounds.width))
    }
}
