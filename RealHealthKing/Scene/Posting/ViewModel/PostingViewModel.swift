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
    }
    
    struct Output {
        let limitedImageCount: Driver<Int>
        let currentImageCount: Driver<Int>
        let hasImages: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let imageCount = BehaviorRelay(value: 0)
        let currentImageCount = BehaviorRelay(value: 1)
        let hasImages = BehaviorRelay(value: false)
        
        input.imageCount.subscribe { count in
            imageCount.accept(5 - count)
            
            currentImageCount.accept(count)
            
            if imageCount.value == 5 {
                hasImages.accept(false)
            } else {
                hasImages.accept(true)
            }
        }.disposed(by: disposeBag)
        
        return Output(limitedImageCount: imageCount.asDriver(), currentImageCount: currentImageCount.asDriver(), hasImages: hasImages.asDriver())
    }
    
}
