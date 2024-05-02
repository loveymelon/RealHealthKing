//
//  ModifyViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/27/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import PhotosUI

class ModifyViewController: BaseViewController<ModifyView> {

    let viewModel = ModifyViewModel()
    
    let disposeBag = DisposeBag()
    
    let inputNickName = BehaviorRelay<String>(value: "")
    let profileImage = BehaviorRelay<String>(value: "")
    let userImagePick = BehaviorRelay<Data>(value: Data())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureNav() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.title = "프로필 수정"
        
        let rightBarButton = UIBarButtonItem(customView: mainView.saveButton)
        
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func bind() {
        let nickResult = mainView.nickTextField.textField.rx.text.orEmpty.asObservable()
        
        let saveButtonTap = mainView.saveButton.rx.tap.withLatestFrom(userImagePick.asObservable())
        
        let input = ModifyViewModel.Input(inputNickName: inputNickName.asObservable(), inputProfileImage: profileImage.asObservable(), inputNick: nickResult, inputSaveButtonTap: saveButtonTap)
        
        let output = viewModel.transform(input: input)
        
        mainView.profileImageView.rx.tapGesture().when(.recognized).bind(with: self) { owner, _ in
            owner.openPhotoLibrary()
        }.disposed(by: disposeBag)
        
        output.outputNick.drive(with: self) { owner, text in
            owner.mainView.nickTextField.textField.text = text
        }.disposed(by: disposeBag)
        
        output.outputProfileImage.drive(with: self) { owner, imageData in
            
            print(imageData)
            
            if !imageData.isEmpty {
                let url = APIKey.baseURL.rawValue + NetworkVersion.version.rawValue + "/" + imageData
                
                print(url)
                
                owner.mainView.profileImageView.downloadImage(imageUrl: url)
            } else {
                owner.mainView.profileImageView.image = UIImage(systemName: "person")
            }
            
        }.disposed(by: disposeBag)
    }

}

extension ModifyViewController {
    private func openPhotoLibrary() {
        
        if PHPhotoLibrary.authorizationStatus() == .authorized || PHPhotoLibrary.authorizationStatus() == .restricted {
            
            var configuration = PHPickerConfiguration()
            
            configuration.selectionLimit = 1
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

extension ModifyViewController: PHPickerViewControllerDelegate, UINavigationControllerDelegate {
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
                    
                    mainView.profileImageView.image = selectedImages.first
                    
                    if let imageData = selectedImages[0].resizeWithWidth(width: 700)?.jpegData(compressionQuality: 1) {
                        userImagePick.accept(imageData)
                    } else {
                        print("이미지 압축 실패")
                    }
                    
                    picker.dismiss(animated: true, completion: nil)
                }
                
            }
            
        }
        
    }
    
}
