//
//  DetailViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/29/24.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewController: BaseViewController<DetailView> {
    
    let postId = BehaviorRelay(value: "")
    
    let disposeBag = DisposeBag()
    
    let viewModel = DetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.scrollView.delegate = self
    }
    
    override func bind() {
        let input = DetailViewModel.Input(inputPostId: postId.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.outputPostData.drive(with: self) { owner, data in
            owner.mainView.contentLabel.text = data.content
            owner.updateImageViews(postData: data.files, width: owner.mainView.bounds.width)
        }.disposed(by: disposeBag)
        
        output.outputLikeValue.drive(mainView.likeButton.rx.isSelected).disposed(by: disposeBag)
        
    }
    
}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        mainView.pageControl.currentPage = Int(round(scrollView.contentOffset.x / UIScreen.main.bounds.width))
    }
}

extension DetailViewController {
    func updateImageViews(postData: [String], width: CGFloat) {
        
        for num in 0..<postData.count {
            let imageView = UIImageView()
            let postionX = width * CGFloat(num)
            
            let width = width
            let height = mainView.scrollView.bounds.height
 
            imageView.frame = CGRect(x: postionX, y: 0, width: width, height: height)
            
            let url = APIKey.baseURL.rawValue + NetworkVersion.version.rawValue + "/" + postData[num]
            
            imageView.downloadImage(imageUrl: url, width: width, height: height)
            
            mainView.scrollView.addSubview(imageView)
            
            mainView.scrollView.contentSize.width = width * CGFloat(1+num)
        }
        
        mainView.pageControl.numberOfPages = postData.count
        
    }
}
