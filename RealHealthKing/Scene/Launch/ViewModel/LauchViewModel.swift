//
//  LauchViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/28/24.
//

import Foundation
import RxSwift
import RxCocoa

class LauchViewModel: ViewModelType {
    
    struct Input {
        let inputViewWillAppear: Observable<Void>
    }
    
    struct Output {
        let outputViewResult: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let viewWillResult = BehaviorRelay(value: false)
        
        input.inputViewWillAppear
            .flatMapLatest { _ -> Observable<Result<Bool, Error>> in
                return Observable.create { observer in
                    let dispatchGroup = DispatchGroup()
                    var error: Error?
                    
                    dispatchGroup.enter()
                    NetworkManager.fetchPosts { result in
                        defer { dispatchGroup.leave() }
                        switch result {
                        case .success:
                            break
                        case .failure(let err):
                            error = err
                        }
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        if let error = error {
                            observer.onNext(.failure(error))
                        } else {
                            observer.onNext(.success(true))
                        }
                        observer.onCompleted()
                    }
                    
                    return Disposables.create()
                }
            }
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    viewWillResult.accept(true)
                case .failure(let error):
                    print(error)
                    viewWillResult.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(outputViewResult: viewWillResult.asDriver())
    }
}
