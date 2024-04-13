//
//  ViewModelType.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/13/24.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}
