//
//  ProfileViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/25/24.
//

import UIKit
import RxSwift
import RxCocoa
import Tabman
import Pageboy
import SnapKit

class ProfileViewController: BaseViewController<ProfileView> {
    
    let viewModel = ProfileViewModel()
    
    let disposeBag = DisposeBag()
    let logoutTap = PublishRelay<Void>()
    let withdrawTap = PublishRelay<Void>()
    
    var imageURL: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ddd", #function)
        
        mainView.scrollView.contentSize.height = UIScreen.main.bounds.height + 20
        
        let logoutAction = UIAction(title: "로그아웃") { [weak self] _ in
            guard let self else { return }
            logoutTap.accept(())
        }
        
        let withdrawAction = UIAction(title: "회원탈퇴") { [weak self] _ in
            guard let self else { return }
            withdrawTap.accept(())
        }
        
        let items = [logoutAction, withdrawAction]
        
        mainView.rightBarButton.rx.menu.onNext(UIMenu(title: "메뉴", children: items))

        print(mainView.tabVC.view.bounds.height)
        
    }
    
    override func bind() {
        let viewWillTrigger = rx.viewWillAppear.map { _ in }
        
        let inputLeftButtonTap = mainView.leftButton.rx.tap.asObservable()
        
        let input = ProfileViewModel.Input(inputViewWillTrigger: viewWillTrigger, inputLeftButtonTap: inputLeftButtonTap, inputLogoutTap: logoutTap.asObservable(), inputWithrowTap: withdrawTap.asObservable())
        
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
            
            owner.imageURL = image
            
            if image.isEmpty {
                owner.mainView.profileImageView.image = UIImage(systemName: "person")
            } else {
                let url = APIKey.baseURL.rawValue + NetworkVersion.version.rawValue + "/" + image
                
                owner.mainView.profileImageView.downloadImage(imageUrl: url)
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
        
        output.outputLogout.drive(with: self) { owner, _ in
            owner.mainView.window?.rootViewController = UINavigationController(rootViewController: SignInViewController())
        }.disposed(by: disposeBag)
        
        output.outputWithdraw.drive(with: self) { owner, isValid in
            if isValid {
                owner.mainView.window?.rootViewController = UINavigationController(rootViewController: SignInViewController())
            }
        }.disposed(by: disposeBag)
        
//        output.postDatas.drive(with: self) { owner, items in
//            let tabVC = TabViewController()
//            
//            owner.mainView.containerView.addSubview(tabVC.view)
//            
//        }.disposed(by: disposeBag)
//        
    }

    override func configureNav() {
        super.configureNav()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: mainView.rightBarButton)
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.largeTitleDisplayMode = .never
        
    }
}

extension ProfileViewController {
    
    func configureUI() {
        
    }
    
}
