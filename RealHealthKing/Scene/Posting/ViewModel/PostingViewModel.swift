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
        
        let textBeginEdit: Observable<String>
        let textEndEdit: Observable<String>
        let textValues: Observable<String>
        
        let saveButtonTap: Observable<[UIImage]>
    }
    
    struct Output {
        let limitedImageCount: Driver<Int>
        let currentImageCount: Driver<Int>
        let hasImages: Driver<Bool>
        
        let outputTextBeginEdit: Driver<Bool>
        let outputTextEndEdit: Driver<Bool>
        let outputTextValue: Driver<String>
        
        let networkSucces: Driver<Bool>
        let outputError: Driver<String>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let imageCount = BehaviorRelay(value: 0)
        let currentImageCount = BehaviorRelay(value: 1)
        let hasImages = BehaviorRelay(value: false)
        
        let resultTextBegin = BehaviorRelay(value: false)
        let resultTextEndEdit = BehaviorRelay(value: false)
        let resultTextValue = BehaviorRelay(value: "")
        
        let networkSuccess = BehaviorRelay(value: false)
        let resultError = BehaviorRelay(value: "")
        
        input.imageCount.subscribe { count in
            imageCount.accept(5 - count)
            
            currentImageCount.accept(count)
            
            if imageCount.value == 5 {
                hasImages.accept(false)
            } else {
                hasImages.accept(true)
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
        
        input.saveButtonTap.subscribe(with: self) { owner, images in
            
            var datas: [Data] = []
            var imageUrl: [String] = []
            
            for image in images {
                if let imageData = image.resizeWithWidth(width: 700)?.jpegData(compressionQuality: 1) {
                    datas.append(imageData)
                    print("success")
                } else {
                    resultError.accept("이미지 압축 실패 다시 시도해주세요")
                }
            }
            
            if !datas.isEmpty {
                NetworkManager.uploadImage(images: datas) { result in
                    
                    switch result {
                    case .success(let data):
                        imageUrl = data
                        print("success2")
                    case .failure(let error):
                        resultError.accept(error.description)
                    }
                    
                    Observable.combineLatest(input.titleText, input.textValues).subscribe { text in
                        
                        NetworkManager.uploadPostContents(model: PostTest(productId: "abc123", title: text.0, content: text.1, files: imageUrl)) { result in
                            switch result {
                            case .success(let data):
                                networkSuccess.accept(true)
                                print("success3")
                            case .failure(let error):
                                resultError.accept(error.description)
                            }
                        }
                        
                    }.disposed(by: owner.disposeBag)
                    
                    resultError.accept("")
                }
            } else {
                resultError.accept("이미지가 없습니다!")
            }
            
            
        }.disposed(by: disposeBag)
        
        input.textValues.subscribe { text in
            
            guard text == "본인의 내용을 작성해주세요" else {
                resultTextValue.accept("본인의 내용을 작성해주세요")
                return
            }
            
            // 글자수 제한
            let maxLength = 100
            if text.count > maxLength {
                resultTextValue.accept(String(text.prefix(maxLength)))
            }
            
            // 줄바꿈(들여쓰기) 제한
            let maxNumberOfLines = 4
            let lineBreakCharacter = "\n"
            let lines = text.components(separatedBy: lineBreakCharacter)
            var consecutiveLineBreakCount = 0 // 연속된 줄 바꿈 횟수
            
            for line in lines {
                if line.isEmpty { // 빈 줄이면 연속된 줄 바꿈으로 간주
                    consecutiveLineBreakCount += 1
                } else {
                    consecutiveLineBreakCount = 0
                }
                
                if consecutiveLineBreakCount > maxNumberOfLines {
                    resultTextValue.accept(String(text.dropLast())) // 마지막 입력 문자를 제거
                    break
                }
            }
        }.disposed(by: disposeBag)
        
        return Output(limitedImageCount: imageCount.asDriver(), currentImageCount: currentImageCount.asDriver(), hasImages: hasImages.asDriver(), outputTextBeginEdit: resultTextBegin.asDriver(), outputTextEndEdit: resultTextEndEdit.asDriver(), outputTextValue: resultTextValue.asDriver(), networkSucces: networkSuccess.asDriver(), outputError: resultError.asDriver())
    }
    
}
