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
    
    var imageURL: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.scrollView.contentSize.height = UIScreen.main.bounds.height + 20
        
    }
    
    override func bind() {
        let viewWillTrigger = rx.viewWillAppear.map { _ in }
        
        let inputLeftButtonTap = mainView.leftButton.rx.tap.asObservable()
        
        let input = ProfileViewModel.Input(inputViewWillTrigger: viewWillTrigger, inputLeftButtonTap: inputLeftButtonTap)
        
        let output = viewModel.transform(input: input)
        
        output.outputLeftButtonTap.drive(with: self) { owner, isValid in
            if isValid {
                let vc = ModifyViewController()
                
                vc.inputNickName.accept(owner.mainView.nicknameLabel.text ?? "empty")
                vc.profileImage.accept(owner.imageURL ?? "")
                
                owner.navigationController?.pushViewController(vc, animated: true)
            }
        }.disposed(by: disposeBag)
        
        output.profileNick.drive(with: self) { owner, nick in
            owner.mainView.nicknameLabel.text = nick
        }.disposed(by: disposeBag)
        
        output.profileImage.drive(with: self) { owner, image in
            let size = owner.mainView.profileImageView.bounds
            
            owner.imageURL = image

            
            if image.isEmpty {
                owner.mainView.profileImageView.image = UIImage(systemName: "person")
            } else {
                let url = APIKey.baseURL.rawValue + NetworkVersion.version.rawValue + "/" + image
                
                owner.mainView.profileImageView.downloadImage(imageUrl: url, width: size.width, height: size.height)
            }
        }.disposed(by: disposeBag)
        
        output.follwingCount.drive(with: self) { owner, count in
            owner.mainView.followingView.countLabel.text = "\(count)"
        }.disposed(by: disposeBag)
        
        output.follwerCount.drive(with: self) { owner, count in
            owner.mainView.follwerView.countLabel.text = "\(count)"
        }.disposed(by: disposeBag)
        
        output.postCount.map { String($0) }.drive(mainView.postView.countLabel.rx.text).disposed(by: disposeBag)
        
        output.leftButton.drive(mainView.leftButton.rx.title()).disposed(by: disposeBag)
        
        output.postDatas.drive(mainView.collectionView.rx.items(cellIdentifier: SearchCollectionViewCell.identifier, cellType: SearchCollectionViewCell.self)) { index, item, cell in
            
            let size = cell.bounds.size
            
            let url = APIKey.baseURL.rawValue + NetworkVersion.version.rawValue + "/" + (item.files.first ?? "empty")
            
            cell.postImageView.downloadImage(imageUrl: url, width: size.width, height: size.height)
            
        }.disposed(by: disposeBag)
        
    }

}
