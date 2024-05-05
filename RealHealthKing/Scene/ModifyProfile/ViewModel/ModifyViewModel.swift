//
//  ModifyViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/27/24.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

final class ModifyViewModel: ViewModelType {
    
    struct Input {
        let inputNickName: Observable<String>
        let inputProfileImage: Observable<String>
        let inputNick: Observable<String>
        let inputSaveButtonTap: Observable<Data>
    }
    
    struct Output {
        let outputNick: Driver<String>
        let outputProfileImage: Driver<String>
        let outputNickValid: Driver<Bool>
        let outputSaveButton: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    
    func transform(input: Input) -> Output {
        let nickResult = BehaviorRelay(value: "")
        let profileImageResult = BehaviorRelay(value: "")
        let nickValidResult = BehaviorRelay(value: false)
        let saveButtonResult = PublishRelay<Bool>()
        
        input.inputNickName.subscribe { text in
            
            nickResult.accept(text)
        }.disposed(by: disposeBag)
        
        input.inputProfileImage.subscribe { text in
            
            if text.isEmpty {
                profileImageResult.accept("")
            } else {
                profileImageResult.accept(text)
            }
        }.disposed(by: disposeBag)
     
        input.inputNick.bind(onNext: { text in
            
            if !text.isEmpty {
                nickResult.accept(text)
            }
            
            if text.count >= 2 && text.count <= 8 {
                nickValidResult.accept(true)
            } else {
                nickValidResult.accept(false)
            }
        }).disposed(by: disposeBag)
        
        input.inputSaveButtonTap.subscribe(with: self) { owner, imageData in
            print("nick", nickResult.value)
            NetworkManager.modifyProfileUpdate(modifyModel: ModifyProfileModel(nick: nickResult.value, profile: imageData)) { result in
                switch result {
                case .success(let data):
                    print(data)
                    saveButtonResult.accept(true)
                case .failure(let error):
                    print(error)
                }
            }
        }.disposed(by: disposeBag)
        
        return Output(outputNick: nickResult.asDriver(), outputProfileImage: profileImageResult.asDriver(), outputNickValid: nickValidResult.asDriver(), outputSaveButton: saveButtonResult.asDriver(onErrorJustReturn: false))
    }
    
    
}
