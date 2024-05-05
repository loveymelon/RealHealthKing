//
//  PostingViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/18/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class PostingViewModel: ViewModelType {
    
    struct Input {
        let imageCount: Observable<Int>
        let titleText: Observable<String>
        let hashText: Observable<String>
        let textValues: Observable<String>
        let saveButtonTap: Observable<(image: [UIImage], postModel: PostingModel)>
        
        let textBeginEdit: Observable<String>
        let textEndEdit: Observable<String>
    }
    
    struct Output {
        let limitedImageCount: Driver<Int>
        let currentImageCount: Driver<Int>
        let hasImages: Driver<Bool>
        
        let outputTextValue: Driver<String>
        let outputTextBeginEdit: Driver<Bool>
        let outputTextEndEdit: Driver<Bool>
        
        let networkSucces: Driver<Bool>
        let outputError: Driver<String>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let imageCount = BehaviorRelay(value: 0)
        let currentImageCount = BehaviorRelay(value: 1)
        let hasImages = BehaviorRelay(value: false)
        
        let resultTextValue = BehaviorRelay(value: "")
        
        let networkSuccess = BehaviorRelay(value: false)
        let resultError = BehaviorRelay(value: "")
        
        let resultTextBegin = BehaviorRelay(value: false)
        let resultTextEndEdit = BehaviorRelay(value: false)
        
        input.imageCount.subscribe { count in
            imageCount.accept(5 - count)
            
            currentImageCount.accept(count)
            
            if imageCount.value == 5 {
                hasImages.accept(false)
            } else {
                hasImages.accept(true)
            }
        }.disposed(by: disposeBag)
        
        input.saveButtonTap.throttle(.seconds(1), scheduler: MainScheduler.instance).subscribe(with: self) { owner, value in
            
            print("tap")
            
            var datas: [Data] = []

            for image in value.image {
                if let imageData = image.resizeWithWidth(width: 700)?.jpegData(compressionQuality: 1) {
                    datas.append(imageData)
                } else {
                    resultError.accept("이미지 압축 실패 다시 시도해주세요")
                }
            }
            
            if !datas.isEmpty {
                NetworkManager.uploadImage(images: datas) { result in
                    
                    switch result {
                    case .success(let data):
                        
                        NetworkManager.uploadPostContents(model: Posts(productId: "myLoveGym", title: value.postModel.title, content: value.postModel.hashTag, content1: value.postModel.content, files: data)).subscribe { result in
                            networkSuccess.accept(true)
                        } onFailure: { error in
                            print(error)
                        }.disposed(by: owner.disposeBag)
                        
                    case .failure(let error):
                        resultError.accept(error.description)
                    }
                }
                    
            } else {
                resultError.accept("이미지가 없습니다!")
            }
            
            
        }.disposed(by: disposeBag)
        
        input.textBeginEdit.subscribe(with: self) { owner, text in
                    if text == "본인의 내용을 작성해주세요" {
                        resultTextBegin.accept(true)
                    } else {
                        resultTextBegin.accept(false)
                    }
                }.disposed(by: disposeBag)

                input.textEndEdit.subscribe(with: self) { owner, text in
                    if text.isEmpty {
                        resultTextEndEdit.accept(true)
                    } else {
                        resultTextEndEdit.accept(false)
                    }
                }.disposed(by: disposeBag)
        
        return Output(limitedImageCount: imageCount.asDriver(), currentImageCount: currentImageCount.asDriver(), hasImages: hasImages.asDriver(), outputTextValue: resultTextValue.asDriver(), outputTextBeginEdit: resultTextBegin.asDriver(), outputTextEndEdit: resultTextEndEdit.asDriver(), networkSucces: networkSuccess.asDriver(), outputError: resultError.asDriver())
    }
    
}
