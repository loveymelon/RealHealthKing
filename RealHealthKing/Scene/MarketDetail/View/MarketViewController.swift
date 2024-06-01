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

    }
    
    override func bind() {
        let messageButtonTap = mainView.chatButton.rx.tap.asObservable()
        
        let input = MarketViewModel.Input(inputPostId: postId.asObservable(), messageButtonTap: messageButtonTap)
        
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
        
        output.outputRoomId.drive(with: self) { owner, model in
            let chatVC = ChatViewController()
    
            chatVC.viewModel.roomId = model.roomId
            print(model.participants[0])
            
            owner.navigationController?.pushViewController(chatVC, animated: true)
            
        }.disposed(by: disposeBag)
    }

}
