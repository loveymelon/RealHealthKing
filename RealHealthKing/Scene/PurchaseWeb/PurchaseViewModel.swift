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
        
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        input.payment.subscribe { payment in
            if let paymentData = payment.element, let data = paymentData {
                
                NetworkManager.checkPayment(model: PurchaseModel(impUid: data.imp_uid, postId: <#T##String#>, productName: , price: <#T##Int#>))
            }
        }
        
        
        
        return Output()
    }
}
