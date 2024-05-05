//
//  ShopPostViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/4/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import PhotosUI
import SnapKit

class ShopPostViewController: BaseViewController<ShopPostView> {

    private var userImageArray: [UIImage] = []
    private var userImages = BehaviorRelay<[UIImage]>(value: [])
    private var configuration = PHPickerConfiguration()
    private var selectedCount = PublishRelay<Int>()
    
    let viewModel = ShopPostViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.priceTextField.rightView = mainView.clearButton
    }
    
    override func bind() {
        
        let textBeginEdit = mainView.detailTextView.rx.didBeginEditing.withLatestFrom(mainView.detailTextView.rx.text.orEmpty.asObservable())
        
        let textEndEdit = mainView.detailTextView.rx.didEndEditing.withLatestFrom(mainView.detailTextView.rx.text.orEmpty.asObservable())
        
        let textValue = mainView.priceTextField.rx.controlEvent([.allEditingEvents, .valueChanged]).withLatestFrom(mainView.priceTextField.rx.text.orEmpty.asObservable())
        
        let imageCount = userImages.map { $0.count }.asObservable()
        
        let saveButton = mainView.saveButton.rx.tap.withUnretained(self).map { owner, _ in
            let mainView = owner.mainView
            
            return (image: owner.userImageArray, postData: Posts(productId: "healthProduct", title: mainView.titleTextField.text, content: mainView.detailTextView.text, content1: mainView.priceTextField.text))
        }
        
        let input = ShopPostViewModel.Input(textBeginEdit: textBeginEdit, textEndEdit: textEndEdit, textValue: textValue, imageCount: imageCount, selectedImageCount: selectedCount.asObservable(), saveButtonTap: saveButton)
        
        let output = viewModel.transform(input: input)
        
        mainView.photoView.rx.tapGesture().when(.recognized).withLatestFrom(userImages).bind(with: self) { owner, images in
            owner.handleImage(images: images)
        }.disposed(by: disposeBag)
        
        mainView.detailTextView.rx.didChange.bind(with: self) { owner, _ in
            
                owner.mainView.detailTextView.isScrollEnabled = false
                owner.mainView.detailTextView.reloadInputViews()
                
            }.disposed(by: disposeBag)
        
        mainView.clearButton.rx.tap.bind(with: self) { owner, _ in
            owner.mainView.priceTextField.text = ""
        }.disposed(by: disposeBag)
        
        output.outputTextBeginEdit.drive(with: self) { owner, isValid in
            if isValid {
                owner.mainView.detailTextView.text = nil
                owner.mainView.detailTextView.textColor = .systemGray5
            }
        }.disposed(by: disposeBag)
        
        output.outputTextEndEdit.drive(with: self) { owner, isValid in
            if isValid {
                owner.mainView.detailTextView.text = "상품에 대한 설명을 자세하게 적어주세요."
                owner.mainView.detailTextView.textColor = .systemGray3
            }
        }.disposed(by: disposeBag)
        
        output.outputTextValue.drive(mainView.priceTextField.rx.text).disposed(by: disposeBag)
        
        output.limitedImageCount.drive(with: self, onNext: { owner, imageCount in
            owner.configuration.selectionLimit = imageCount
        }).disposed(by: disposeBag)
        
        output.currentImageCount.drive(with: self) { owner, count in
            
            owner.mainView.photoView.countLabel.text = "\(count)/5"
            
        }.disposed(by: disposeBag)
        
        output.selectedImageCount.drive(with: self) { owner, beforeImageCount in
            
            for index in beforeImageCount...(owner.userImageArray.count - 1) {
                let shopPostPhotoImageView = ShopPostPhotoView()
                
                shopPostPhotoImageView.snp.makeConstraints { make in
                    make.size.equalTo(70)
                }
                
                shopPostPhotoImageView.cancelButton.rx.tap.bind(with: self) { owner, _ in
                    
                    if let index = owner.mainView.hStackView.subviews.firstIndex(of: shopPostPhotoImageView) {
                        owner.userImageArray.remove(at: index-1)
                    } else {
                        print("noView")
                    }

                    owner.userImages.accept(owner.userImageArray)
                    shopPostPhotoImageView.removeFromSuperview()
                    
                }.disposed(by: owner.disposeBag)
                
                shopPostPhotoImageView.imageView.image = owner.userImageArray[index]
                
                owner.mainView.hStackView.addArrangedSubview(shopPostPhotoImageView)
            }
        }.disposed(by: disposeBag)
        
        output.networkResult.drive(with: self) { owner, isValid in
            if isValid {
                owner.navigationController?.popViewController(animated: true)
            }
        }.disposed(by: disposeBag)
        
        output.errorResult.drive(with: self) { owner, text in
            owner.mainView.makeToast(text, duration: 1.0, position: .center)
        }
    }

}

extension ShopPostViewController: PHPickerViewControllerDelegate, UINavigationControllerDelegate {
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
                    
                    let before = userImageArray.count
                    
                    userImageArray.append(contentsOf: selectedImages)
                    userImages.accept(userImageArray)
                    selectedCount.accept(before)
                    
                    picker.dismiss(animated: true, completion: nil)
                }
                
            }
            
        }
        
    }
    
}

extension ShopPostViewController {
    func handleImage(images: [UIImage]) {
        photoAuth()
        
        if images.count != 5 {
            openPhotoLibrary()
        } else {
            print("aa")
        }
//        showImageAlert(bool: true) { [unowned self] in
//            
//            if images.count != 0 {
////                userImageArray.remove(at: mainView.pageControl.currentPage)
//                userImages.accept(userImageArray)
//            } else {
//                mainView.makeToast("사진이 5개 일때는 삭제가 불가능합니다.", duration: 1.0, position: .center)
//            }
//            
//        } completionHandler: { [unowned self] in
//            
//            if images.count != 5 {
//                openPhotoLibrary()
//            } else {
//                mainView.makeToast("사진은 최대 5개까지 등록가능합니다.", duration: 1.0, position: .center)
//            }
//        }
    }
    
    func photoAuth() {
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
    
    func openPhotoLibrary() {
        
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
