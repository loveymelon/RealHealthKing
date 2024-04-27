//
//  ProfileViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/25/24.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: BaseViewController<ProfileView> {
    
    let viewModel = ProfileViewModel()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.scrollView.contentSize.height = UIScreen.main.bounds.height + 20
        
    }
    
    override func bind() {
        let viewWillTrigger = rx.viewWillAppear.map { _ in }
        
        let input = ProfileViewModel.Input(inputViewWillTrigger: viewWillTrigger)
        
        let output = viewModel.transform(input: input)
        
        output.profileNick.drive(with: self) { owner, nick in
            owner.mainView.nicknameLabel.text = nick
        }.disposed(by: disposeBag)
        
        output.profileImage.drive(with: self) { owner, image in
            let size = owner.mainView.profileImageView.bounds
            
            if image.isEmpty {
                owner.mainView.profileImageView.image = UIImage(systemName: "person")
            } else {
                owner.mainView.profileImageView.downloadImage(imageUrl: image, width: size.width, height: size.height)
            }
        }.disposed(by: disposeBag)
        
        output.follwingCount.drive(with: self) { owner, count in
            owner.mainView.followingView.countLabel.text = "\(count)"
        }.disposed(by: disposeBag)
        
        output.follwerCount.drive(with: self) { owner, count in
            owner.mainView.follwerView.countLabel.text = "\(count)"
        }.disposed(by: disposeBag)
        
        output.postDatas.drive(mainView.collectionView.rx.items(cellIdentifier: SearchCollectionViewCell.identifier, cellType: SearchCollectionViewCell.self)) { index, item, cell in
            
            let size = cell.bounds.size
            
            let url = APIKey.baseURL.rawValue + NetworkVersion.version.rawValue + "/" + (item.files.first ?? "empty")
            
             print(url)
            cell.postImageView.downloadImage(imageUrl: url, width: size.width, height: size.height)
            
        }.disposed(by: disposeBag)
        
    }

}
