//
//  HomeTableCellViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/23/24.
//

import Foundation
import RxSwift
import RxCocoa

class HomeTableCellViewModel: ViewModelType {
    struct Input {
        let likeButtonTap: Observable<Void>
    }
    
    struct Output {
        
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        
        
        return Output()
    }
}
