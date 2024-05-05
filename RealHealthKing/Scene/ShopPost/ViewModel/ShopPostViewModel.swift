//
//  ShopPostViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/4/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class ShopPostViewModel: ViewModelType {
    struct Input {
        let textBeginEdit: Observable<String>
        let textEndEdit: Observable<String>
        let textValue: Observable<String>
        let imageCount: Observable<Int>
        let selectedImageCount: Observable<Int>
        let saveButtonTap: Observable<(image: [UIImage], postData: Posts)>
    }
    
    struct Output {
        let outputTextBeginEdit: Driver<Bool>
        let outputTextEndEdit: Driver<Bool>
        let outputTextValue: Driver<String>
        let limitedImageCount: Driver<Int>
        let currentImageCount: Driver<Int>
        let selectedImageCount: Driver<Int>
        let networkResult: Driver<Bool>
        let errorResult: Driver<String>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let resultTextBegin = BehaviorRelay(value: false)
        let resultTextEndEdit = BehaviorRelay(value: false)
        
        let resultTextValue = PublishRelay<String>()
        
        let imageCount = BehaviorRelay(value: 5)
        let currentImageCount = PublishRelay<Int>()
        
        let resultError = PublishRelay<String>()
        let networkResult = BehaviorRelay(value: false)
        
        input.textBeginEdit.subscribe(with: self) { owner, text in
                    if text == "상품에 대한 설명을 자세하게 적어주세요." {
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
        
        input.textValue.subscribe { text in
            resultTextValue.accept(text.addComma(to: text))
        }.disposed(by: disposeBag)
        
        input.imageCount.subscribe { count in
            
//            imageCount.accept(5 - count)
            if let num = count.element {
        
                imageCount.accept(5 - num)
                currentImageCount.accept(num)
            }
            
        }.disposed(by: disposeBag)
        
        input.saveButtonTap.subscribe(with: self) { owner, value in
            
            let checkData = value.postData
            
            guard let title = checkData.title, let price = checkData.content1 else { return }
            
            var datas: [Data] = []
            
            for image in value.image {
                if let imageData = image.resizeWithWidth(width: 700)?.jpegData(compressionQuality: 1) {
                    datas.append(imageData)
                } else {
                    resultError.accept("이미지 압축 실패 다시 시도해주세요")
                }
            }
            
            if !datas.isEmpty {
                
                if title.isEmpty {
                    resultError.accept("상품명을 명시해주세요")
                } else if price.isEmpty {
                    resultError.accept("가격을 명시해주세요")
                } else {
                    print("dddd")
                    NetworkManager.uploadImage(images: datas) { result in
                        
                        switch result {
                        case .success(let data):
                            
                            NetworkManager.uploadPostContents(model: Posts(productId: value.postData.productId, title: value.postData.title, content: value.postData.content, content1: value.postData.content1, files: data)).subscribe { result in
                                networkResult.accept(true)
                            } onFailure: { error in
                                print(error)
                            }.disposed(by: owner.disposeBag)
                            
                        case .failure(let error):
                            resultError.accept(error.description)
                        }
                    }
                }
                
            } else {
                resultError.accept("이미지가 없습니다!")
            }
        }.disposed(by: disposeBag)
        
        return Output(outputTextBeginEdit: resultTextBegin.asDriver(), outputTextEndEdit: resultTextEndEdit.asDriver(), outputTextValue: resultTextValue.asDriver(onErrorJustReturn: ""), limitedImageCount: imageCount.asDriver(), currentImageCount: currentImageCount.asDriver(onErrorJustReturn: 0), selectedImageCount:  input.selectedImageCount.asDriver(onErrorJustReturn: 0), networkResult: networkResult.asDriver(), errorResult: resultError.asDriver(onErrorJustReturn: ""))
    }
}
