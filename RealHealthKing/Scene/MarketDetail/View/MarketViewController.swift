//
//  MarketViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/15/24.
//

import UIKit
import RxSwift
import RxCocoa

class MarketViewController: BaseViewController<MarketView> {

    let postId = BehaviorRelay(value: "")
    var createrId = ""
    
    let disposeBag = DisposeBag()
    
    let viewModel = MarketViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.changeTabBar(hidden: true, animated: false)
    }

    override func bind() {
        let input = MarketViewModel.Input(inputPostId: postId.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.outputPostData.drive(with: self) { owner, data in
            
            owner.mainView.updateImageViews(scrollView: owner.mainView.scrollView, pageControl: owner.mainView.pageControl, postData: data.files, width: owner.mainView.frame.width)
            
            owner.mainView.nickLabel.text = data.creator.nick
            owner.mainView.titleLabel.text = data.title
            owner.mainView.commentLabel.text = data.content
            owner.createrId = data.creator.userId
            
            if let price = data.content1 {
                owner.mainView.priceLabel.text = "가격 \(price.extractNumbers(from: price))원"
            } else {
                owner.mainView.priceLabel.text = "0원"
            }
            
            if let imageUrl = data.creator.profileImage {
                
                let url = APIKey.baseURL.rawValue + NetworkVersion.version.rawValue + "/" + imageUrl
                owner.mainView.profileImageView.downloadImage(imageUrl: url)
                
                
            } else {
                owner.mainView.profileImageView.image = UIImage(systemName: "person")
            }
            
            
        }.disposed(by: disposeBag)
        
        mainView.chatButton.rx.tap.withUnretained(self).flatMap { owner, _ in
//            return NetworkManager.connectChat(userId: owner.createrId)
            return NetworkManager.fetchChatRoom()
        }.bind(with: self) { owner, result  in
            
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
            
        }.disposed(by: disposeBag)
    }

}
