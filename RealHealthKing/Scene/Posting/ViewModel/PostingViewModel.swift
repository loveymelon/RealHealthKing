//
//  PostingViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/18/24.
//

import Foundation
import RxSwift
import RxCocoa

class PostingViewModel: ViewModelType {
    
    struct Input {
        let imageCount: Observable<Int>
        let textBeginEdit: Observable<String>
        let textEndEdit: Observable<String>
    }
    
    struct Output {
        let limitedImageCount: Driver<Int>
        let currentImageCount: Driver<Int>
        let hasImages: Driver<Bool>
        
        let outputTextBeginEdit: Driver<Bool>
        let outputTextEndEdit: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let imageCount = BehaviorRelay(value: 0)
        let currentImageCount = BehaviorRelay(value: 1)
        let hasImages = BehaviorRelay(value: false)
        
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
        
        return Output(limitedImageCount: imageCount.asDriver(), currentImageCount: currentImageCount.asDriver(), hasImages: hasImages.asDriver(), outputTextBeginEdit: resultTextBegin.asDriver(), outputTextEndEdit: resultTextEndEdit.asDriver())
    }
    
}
