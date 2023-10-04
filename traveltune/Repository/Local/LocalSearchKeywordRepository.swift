//
//  LocalSearchKeywordRepository.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/04.
//

import Foundation
import RealmSwift

final class LocalSearchKeywordRepository: RealmProtocol {
    
    typealias T = SearchKeyword
    
    private let realm = try? Realm()
    
    func fetch() -> Results<SearchKeyword>? {
        return realm?.objects(SearchKeyword.self)
    }
    
    func fetchFilter(_ isIncluded: ((Query<SearchKeyword>) -> Query<Bool>)) -> Results<SearchKeyword>? {
        return realm?.objects(SearchKeyword.self).where { isIncluded($0) }
    }
    
    func objectByPrimaryKey<KeyType>(primaryKey: KeyType) -> SearchKeyword? {
        return realm?.object(ofType: SearchKeyword.self, forPrimaryKey: primaryKey)
    }
    
    func create(_ item: SearchKeyword, errorHandler: () -> Void) {
        do {
            try realm?.write {
                realm?.add(item)
            }
        } catch {
            errorHandler()
        }
    }
    
    func update(_ item: SearchKeyword, errorHandler: () -> Void) {
        do {
            try realm?.write {
                realm?.create(
                    SearchKeyword.self,
                    value: item,
                    update: .modified
                )
            }
        } catch {
            errorHandler()
        }
    }
    
    func delete(_ item: SearchKeyword, errorHandler: () -> Void) {
        do {
            try realm?.write {
                realm?.delete(item)
            }
        } catch  {
            errorHandler()
        }
    }
    
}
