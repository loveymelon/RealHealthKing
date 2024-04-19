//
//  PostingViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/18/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI
import RxGesture

class PostingViewController: BaseViewController<PostingView> {
    
    let viewModel = PostingViewModel()
    
    let disposeBag = DisposeBag()
    
    var userImageArray: [UIImage] = []
    var userImages = BehaviorRelay<[UIImage]>(value: [])
    var configuration = PHPickerConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.scrollView.delegate = self
    }
    
    override func bind() {

        let imageCount = userImages.map { $0.count }.asObservable()

        let input = PostingViewModel.Input(imageCount: imageCount)
        
        let output = viewModel.transform(input: input)
        
        // TextView placeholder 설정
        let textView = mainView.memoTextView
        
        textView.rx.didBeginEditing
            .bind(with: self, onNext: { owner, _ in
                if textView.text == "본인의 내용을 작성해주세요" {
                    textView.text = nil
                    textView.textColor = .systemGray5
                    
                }
            }).disposed(by: disposeBag)
        
        textView.rx.didEndEditing
            .bind(with: self, onNext: { owner, _ in
                if(textView.text == nil || textView.text == ""){
                    textView.text = "본인의 내용을 작성해주세요"
                    textView.textColor = .systemGray3
                    
                }
            }).disposed(by: disposeBag)
        
        // 터치시 갤러리 접근
        mainView.scrollView.rx.tapGesture().when(.recognized).bind(with: self) { owner, _ in
            owner.photoAuth()
            owner.showImageAlert(bool: true) {
                owner.userImageArray.remove(at: owner.mainView.pageControl.currentPage)
                print(owner.userImageArray.count)
            } completionHandler: {
                owner.openPhotoLibrary()
            }

        }.disposed(by: disposeBag)
        
        // 이미지 선택 제한
        output.limitedImageCount.drive(with: self, onNext: { owner, imageCount in
            owner.configuration.selectionLimit = imageCount
        }).disposed(by: disposeBag)
        
        output.currentImageCount.drive(with: self) { owner, imageCount in
            
            if imageCount == 0 {
                owner.mainView.imageNumberLabel.isHidden = true
                owner.mainView.imageInfoLabel.isHidden = false
                return
            } else {
                owner.mainView.imageNumberLabel.isHidden = false
                owner.mainView.imageInfoLabel.isHidden = true
            }
            
            for num in 0..<imageCount {
                let imageView = UIImageView()
                let postionX = owner.mainView.frame.width * CGFloat(num)
                imageView.frame = CGRect(x: postionX, y: 0, width: owner.mainView.frame.width, height: owner.mainView.scrollView.bounds.height)
                
                imageView.image = owner.userImageArray[num]
                owner.mainView.scrollView.addSubview(imageView)
                
                owner.mainView.scrollView.contentSize.width = owner.mainView.frame.width * CGFloat(1+num) // scrollView의 넓이 설정
            }
            
            owner.mainView.pageControl.numberOfPages = imageCount
            
        }.disposed(by: disposeBag)
        
    }
    
    private func photoAuth() {
        let requiredAccessLevel: PHAccessLevel = .readWrite
        PHPhotoLibrary.requestAuthorization(for: requiredAccessLevel) { [weak self] authorizationStatus in
            
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch authorizationStatus {
                case .denied, .notDetermined, .limited:
                    self.showSettingAlert(title: "사진 라이브러리 권한 필요", message: "사진을 선택하려면 사진 라이브러리 권한이 필요합니다. 설정에서 권한을 변경할 수 있습니다.")
                case .authorized, .restricted:
                    break
                default:
                    self.showSettingAlert(title: "사진 라이브러리 권한 필요", message: "사진을 선택하려면 사진 라이브러리 권한이 필요합니다. 설정에서 권한을 변경할 수 있습니다.")
                }
            }
        }
    }
    
    private func openPhotoLibrary() {
        
        if PHPhotoLibrary.authorizationStatus() == .authorized || PHPhotoLibrary.authorizationStatus() == .restricted {
            
            configuration.filter = .any(of: [.images])
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
           
            self.present(picker, animated: true)
        } else {
            DispatchQueue.main.async {
                self.showSettingAlert(title: "사진 라이브러리 권한 필요", message: "사진을 선택하려면 사진 라이브러리 권한이 필요합니다. 설정에서 권한을 변경할 수 있습니다.")
            }
            
        }
    }
    
//    func selectedPage(currentPage: Int) {
//        mainView.pageControl.currentPage = currentPage
//    }

}

// 선택할때마다 뷰모델

extension PostingViewController: PHPickerViewControllerDelegate, UINavigationControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        var selectedImages: [UIImage] = []
        
        for result in results where result.itemProvider.canLoadObject(ofClass: UIImage.self) {
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, _ ) in
                guard let self = self else { return }
                
                guard let image = image as? UIImage else { return }
                selectedImages.append(image)
                
                guard selectedImages.count == results.count else { return }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    userImageArray.append(contentsOf: selectedImages)
                    userImages.accept(userImageArray)
                    
                    picker.dismiss(animated: true, completion: nil)
                }
                
            }
            
        }
        
    }
    
}

extension PostingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        mainView.pageControl.currentPage = Int(round(mainView.scrollView.contentOffset.x / UIScreen.main.bounds.width))
        mainView.imageNumberLabel.text = "\(mainView.pageControl.currentPage+1)/\(mainView.pageControl.numberOfPages)"
    }
}
