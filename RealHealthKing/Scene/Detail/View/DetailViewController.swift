//
//  DetailViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/29/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class DetailViewController: BaseViewController<DetailView> {
    
    let postId = BehaviorRelay(value: "")
    
    let disposeBag = DisposeBag()
    
    let viewModel = DetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.scrollView.delegate = self
        
    }
    
    override func bind() {
        let profileImageViewTap = mainView.profileImageView.rx.tapGesture().when(.recognized).asObservable()
        
        let input = DetailViewModel.Input(inputPostId: postId.asObservable(), inputProfileImageTap: profileImageViewTap)
        
        let output = viewModel.transform(input: input)
        
        output.outputPostData.drive(with: self) { owner, data in
            owner.mainView.nickNameLabel.text = data.creator.nick
            owner.mainView.contentLabel.text = data.content
            
            owner.mainView.updateImageViews(scrollView: owner.mainView.scrollView, pageControl: owner.mainView.pageControl, postData: data.files, width: owner.mainView.bounds.width)
            
            if let imageUrl = data.creator.profileImage {
                let url = APIKey.baseURL.rawValue + NetworkVersion.version.rawValue + "/" + imageUrl
                
                owner.mainView.profileImageView.downloadImage(imageUrl: url)
            }
        }.disposed(by: disposeBag)
        
        output.outputLikeValue.drive(mainView.likeButton.rx.isSelected).disposed(by: disposeBag)
        
        output.outputVC.drive(with: self) { owner, value in
            let vc = ProfileViewController()
            
            vc.viewModel.viewState = value.enumValue
            vc.viewModel.otherUserId = value.userId
            
            owner.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
    }
    
    override func configureNav() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        mainView.pageControl.currentPage = Int(round(scrollView.contentOffset.x / UIScreen.main.bounds.width))
    }
}
