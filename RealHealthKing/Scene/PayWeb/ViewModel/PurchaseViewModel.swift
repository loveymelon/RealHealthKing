//
//  PurchaseViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/5/24.
//

import Foundation
import RxSwift
import RxCocoa
import iamport_ios

class PurchaseViewModel: ViewModelType {
    struct Input {
        let payment: Observable<IamportResponse?>
    }
    
    struct Output {
        let resultData: Driver<Bool>
    }
    
    var postData: Posts?
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let resultData = PublishRelay<Bool>()
        
        input.payment.withUnretained(self).flatMap{ owner, payment in
            
            print(owner.postData?.postId)
            
            return NetworkManager.checkPayment(model: PurchaseModel(impUid: payment?.imp_uid ?? "empty", postId: owner.postData?.postId ?? "empty", productName: owner.postData?.title ?? "empty", price: Int(owner.postData?.content1 ?? "0") ?? 0 ))
            
        }.withUnretained(self).subscribe { owner, result in
            
            switch result {
            case .success(let data):
                print("purchase", data)
                resultData.accept(true)
            case .failure(let error):
                print(error)
                resultData.accept(false)
            }
        } onError: { error in
            print(error)
        }.disposed(by: disposeBag)
        
        return Output(resultData: resultData.asDriver(onErrorJustReturn: false))
    }
}
