//
//  CommentViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/29/24.
//

import UIKit
import RxSwift
import RxCocoa

class CommentViewController: BaseViewController<CommentView> {
    
    let postId = BehaviorRelay(value: "")
    
    let viewModel = CommentViewModel()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSheet()
        
    }
    
    override func bind() {
        mainView.tableView.keyboardDismissMode = .onDrag
        
        rx.viewWillDisappear.take(1).bind(with: self) { owner, _ in
            owner.view.endEditing(true)
        }.disposed(by: disposeBag)
        
        let viewWill = rx.viewWillAppear.withLatestFrom(postId.asObservable())
        
        let inputButtonTap = mainView.doneButton.rx.tap.withLatestFrom(mainView.commentTextView.rx.text.orEmpty.asObservable())
        
        let input = CommentViewModel.Input(inputViewWillAppear: viewWill, inputButtonTap: inputButtonTap)
        
        let output = viewModel.transform(input: input)
        
        mainView.commentTextView.rx
            .didChange
            .bind(with: self) { owner, _ in
                let size = CGSize(width: owner.mainView.commentTextView.bounds.width, height: .infinity)
                let estimatedSize = owner.mainView.commentTextView.sizeThatFits(size)
                
                let isMaxHeight = estimatedSize.height >= 103.0
                
                guard isMaxHeight != owner.mainView.commentTextView.isScrollEnabled else { return }
                owner.mainView.commentTextView.isScrollEnabled = isMaxHeight
                owner.mainView.commentTextView.reloadInputViews()
                owner.mainView.commentTextView.setNeedsUpdateConstraints()
            }.disposed(by: disposeBag)
        
        output.outputCommentData.drive(mainView.tableView.rx.items(cellIdentifier: CommentTableViewCell.identifier, cellType: CommentTableViewCell.self)) { index, item, cell in
            
            cell.nickLabel.text = item.creator.nick
            cell.commentLabel.text = item.content
            
            if let imageData = item.creator.profileImage {
                
                let url = APIKey.baseURL.rawValue + NetworkVersion.version.rawValue + "/" + imageData
                
                cell.profileImageView.downloadImage(imageUrl: url)
                
            } else {
                cell.profileImageView.image = UIImage(systemName: "person")
            }
            
        }.disposed(by: disposeBag)
        
        output.outputNoData.drive(with: self) { owner, isValid in
            owner.mainView.noDataView.isHidden = !isValid
            owner.mainView.tableView.isHidden = isValid
        }.disposed(by: disposeBag)
        
        output.outputProfile.drive(with: self) { owner, image in
            if image == "person" {
                owner.mainView.userImageView.image = UIImage(systemName: image)
            } else {
                let url = APIKey.baseURL.rawValue + NetworkVersion.version.rawValue + "/" + image
                
//                print(url, "urlrlrlrlrl")
                
                owner.mainView.userImageView.downloadImage(imageUrl: url)
            }
        }.disposed(by: disposeBag)
    }
    
    override func configureNav() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.title = "댓글"
        navigationController?.navigationBar.isTranslucent = true
    }

}

extension CommentViewController {
    func setupSheet() {
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium(), .large(), .medium()]
            sheet.selectedDetentIdentifier = .medium
            sheet.preferredCornerRadius = 20
            sheet.prefersGrabberVisible = true
            sheet.delegate = self
        }
    }
}

extension CommentViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        sheetPresentationController.animateChanges {
            sheetPresentationController.selectedDetentIdentifier = .medium
            sheetPresentationController.selectedDetentIdentifier = .large
        }
    }
}
