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
            
            for image in images {
                if let imageData = image.resizeWithWidth(width: 700)?.jpegData(compressionQuality: 1) {
                    print(imageData.count)
                    datas.append(imageData)
                } else {
                    print("Failed to get image data.")
                }
            }
            
            if !datas.isEmpty {
                NetworkManager.uploadImage(images: datas)
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
        
        return Output(limitedImageCount: imageCount.asDriver(), currentImageCount: currentImageCount.asDriver(), hasImages: hasImages.asDriver(), outputTextBeginEdit: resultTextBegin.asDriver(), outputTextEndEdit: resultTextEndEdit.asDriver(), outputTextValue: resultTextValue.asDriver(), outputError: resultError.asDriver())
    }
    
}
