//
//  ShopTableViewCellViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class ShopTableViewCellViewModel: ViewModelType {
    struct Input {
        let purchaseButton: Observable<Posts>
    }
    
    struct Output {
        
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        
        
        return Output()
    }
}
