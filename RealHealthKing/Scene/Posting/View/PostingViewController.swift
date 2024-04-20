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
import Toast

final class PostingViewController: BaseViewController<PostingView> {
    
    private let viewModel = PostingViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var userImageArray: [UIImage] = []
    private var userImages = BehaviorRelay<[UIImage]>(value: [])
    private var configuration = PHPickerConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.scrollView.delegate = self
    }
    
    override func configureNav() {
        let rightBarButton = UIBarButtonItem(customView: mainView.saveButton)
        
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func bind() {
        
        let textView = mainView.memoTextView

        let imageCount = userImages.map { $0.count }.asObservable()
        
        let textBeginEdit = textView.rx.didBeginEditing.withLatestFrom(textView.rx.text.orEmpty.asObservable())
        let textEndEdit = textView.rx.didEndEditing.withLatestFrom(textView.rx.text.orEmpty.asObservable())
        let textValues = textView.rx.text.orEmpty.asObservable()
        
        let saveButtonTap = mainView.saveButton.rx.tap.asObservable()

        let input = PostingViewModel.Input(imageCount: imageCount, textBeginEdit: textBeginEdit, textEndEdit: textEndEdit, textValues: textValues, saveButtonTap: saveButtonTap)
        
        let output = viewModel.transform(input: input)
        
        // TextView placeholder 설정
        
        output.outputTextBeginEdit.drive(with: self) { owner, isValid in
            if isValid {
                textView.text = nil
                textView.textColor = .systemGray5
                owner.mainView.imageNumberLabel.text = "0/100"
            }
        }.disposed(by: disposeBag)
        
        output.outputTextEndEdit.drive(with: self) { owner, isValid in
            if isValid {
                textView.text = "본인의 내용을 작성해주세요"
                textView.textColor = .systemGray3
                owner.mainView.imageNumberLabel.text = "0/100"
            }
        }.disposed(by: disposeBag)
        
        output.outputTextValue.drive(with: self) { owner, text in
            textView.text = text
            owner.mainView.imageNumberLabel.text = "\(text.count)/100"
        }.disposed(by: disposeBag)
        
        mainView.scrollView.rx.tapGesture().when(.recognized).withLatestFrom(userImages).bind(with: self) { owner, images in
            owner.handleImage(images: images)
        }.disposed(by: disposeBag)
        
        // 터치시 갤러리 접근
        
        // 이미지 선택 제한
        output.limitedImageCount.drive(with: self, onNext: { owner, imageCount in
            owner.configuration.selectionLimit = imageCount
        }).disposed(by: disposeBag)
        
        // 이미지 수에 맞는 UI변경
        output.currentImageCount.drive(with: self) { owner, imageCount in
            
            owner.updateImageLabels(imageCount: imageCount)
            
            owner.updateImageViews(imageCount: imageCount)
            
        }.disposed(by: disposeBag)
        
    }
    
}

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

extension PostingViewController {
    
    private func handleImage(images: [UIImage]) {
        photoAuth()
        showImageAlert(bool: true) { [unowned self] in
            
            if images.count != 0 {
                userImageArray.remove(at: mainView.pageControl.currentPage)
                userImages.accept(userImageArray)
            } else {
                mainView.makeToast("사진이 5개 일때는 삭제가 불가능합니다.", duration: 1.0, position: .center)
            }
            
        } completionHandler: { [unowned self] in
            
            if images.count != 5 {
                openPhotoLibrary()
            } else {
                mainView.makeToast("사진은 최대 5개까지 등록가능합니다.", duration: 1.0, position: .center)
            }
        }
    }
    
    private func updateImageViews(imageCount: Int) {
        
        for num in 0..<imageCount {
            let imageView = UIImageView()
            let postionX = mainView.frame.width * CGFloat(num)
            imageView.frame = CGRect(x: postionX, y: 0, width: mainView.frame.width, height: mainView.scrollView.bounds.height)
            
            imageView.image = userImageArray[num]
            mainView.scrollView.addSubview(imageView)
            
            mainView.scrollView.contentSize.width = mainView.frame.width * CGFloat(1+num) // scrollView의 넓이 설정
        }
        
        mainView.pageControl.numberOfPages = imageCount
        
    }
    
    func updateImageLabels(imageCount: Int) {
        if imageCount == 0 {
            mainView.imageNumberLabel.isHidden = true
            mainView.imageInfoLabel.isHidden = false
            return
        } else {
            mainView.imageNumberLabel.isHidden = false
            mainView.imageInfoLabel.isHidden = true
        }
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
            configuration.preferredAssetRepresentationMode = .current
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
           
            self.present(picker, animated: true)
        } else {
            DispatchQueue.main.async {
                self.showSettingAlert(title: "사진 라이브러리 권한 필요", message: "사진을 선택하려면 사진 라이브러리 권한이 필요합니다. 설정에서 권한을 변경할 수 있습니다.")
            }
            
        }
    }
}
