//
//  SearchViewModel.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/24/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class SearchViewModel: ViewModelType {
    struct Input {
        let viewWillAppearTrigger: Observable<Void>
        let searchButtonTap: Observable<String>
        let searchCancelTap: ControlEvent<Void>
        let collectionCellIndex: Observable<(cell: UICollectionViewCell, at: IndexPath)>
    }
    
    struct Output {
        let postDatas: Driver<[Posts]>
        let noData: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    
    func transform(input: Input) -> Output {
        
        var originPosts: [Posts] = []
        var postsTitle: [String] = []
        let postsDatas = BehaviorRelay<[Posts]>(value: [])
        var cursor = ""
        let noDataResult = PublishSubject<Bool>()
        
        input.viewWillAppearTrigger.subscribe { _ in
            NetworkManager.fetchPosts { result in
                switch result {
                case .success(let data):
                    originPosts = data.data
                    postsDatas.accept(data.data)
                    cursor = data.nextCursor
                    
                    noDataResult.onNext(data.data.isEmpty)
                    
                    for item in data.data {
                        guard let title = item.title else { return }
                        postsTitle.append(title)
                    }
                    
                case .failure(let failure):
                    print(failure)
                }
            }
        }.disposed(by: disposeBag)
        
        input.searchButtonTap.subscribe { searchText in
            
            print("taptaptap", searchText)
            
            if searchText == "전체" {
                postsDatas.accept(originPosts)
                noDataResult.onNext(false)
                print(originPosts)
            } else {
                
                NetworkManager.searchHashTag(hashTag: searchText) { result in
                    switch result {
                    case .success(let data):
                        postsDatas.accept(data.data)
                        noDataResult.onNext(data.data.isEmpty)
                        
                        cursor = data.nextCursor
                    case .failure(let error):
                        print(error)
                    }
                }
                
            }
            
        }.disposed(by: disposeBag)
        
        input.collectionCellIndex.subscribe(with: self) { owner, item in
            
            if item.1.row == postsDatas.value.count - 1 && cursor != "0" {
                NetworkManager.pagePosts(cursor: cursor) { result in
                    
                    switch result {
                    case .success(let data):
                        
                        cursor = data.nextCursor
                        
                        let temp = postsDatas.value + data.data
                        postsDatas.accept(temp)
                        
                        for item in data.data {
                            guard let title = item.title else { return }
                            
                            postsTitle.append(title)
                        }
                        
                        if cursor == "0" {
                            owner.disposeBag = DisposeBag()
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                }
                
            }
        }.disposed(by: disposeBag)
        
        return Output(postDatas: postsDatas.asDriver(), noData: noDataResult.asDriver(onErrorJustReturn: false))
    }
}
