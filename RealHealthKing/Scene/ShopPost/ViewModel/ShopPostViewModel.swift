//
//  ShopPostViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/4/24.
//

import Foundation
import RxSwift
import RxCocoa

class ShopPostViewModel: ViewModelType {
    struct Input {
        let textBeginEdit: Observable<String>
        let textEndEdit: Observable<String>
        let textValue: Observable<String>
        let imageCount: Observable<Int>
        let selectedImageCount: Observable<Int>
    }
    
    struct Output {
        let outputTextBeginEdit: Driver<Bool>
        let outputTextEndEdit: Driver<Bool>
        let outputTextValue: Driver<String>
        let limitedImageCount: Driver<Int>
        let currentImageCount: Driver<Int>
        let selectedImageCount: Driver<Int>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let resultTextBegin = BehaviorRelay(value: false)
        let resultTextEndEdit = BehaviorRelay(value: false)
        
        let resultTextValue = PublishRelay<String>()
        
        let imageCount = BehaviorRelay(value: 5)
        let currentImageCount = PublishRelay<Int>()
        
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
        
        return Output(outputTextBeginEdit: resultTextBegin.asDriver(), outputTextEndEdit: resultTextEndEdit.asDriver(), outputTextValue: resultTextValue.asDriver(onErrorJustReturn: ""), limitedImageCount: imageCount.asDriver(), currentImageCount: currentImageCount.asDriver(onErrorJustReturn: 0), selectedImageCount:  input.selectedImageCount.asDriver(onErrorJustReturn: 0))
    }
}
