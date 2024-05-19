//
//  RealmRepository.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/19/24.
//

import RealmSwift

final class RealmRepository {
    private let realm = try! Realm()
    
    func createItem(item: RealmModel) throws {
        
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            throw RealmError.createFail
        }
        
    }
    
    func fetchItem() -> Results<RealmModel> {
        return realm.objects(RealmModel.self)
    }
    
    
}
