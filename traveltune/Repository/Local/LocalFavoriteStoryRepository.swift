//
//  LocalFavoriteStoryRepository.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/01.
//

import Foundation
import RealmSwift

final class LocalFavoriteStoryRepository: RealmProtocol {
    
    typealias T = FavoriteStory
    
    private let realm = try? Realm()
    
    func fetch() -> Results<FavoriteStory>? {
        return realm?.objects(FavoriteStory.self)
    }
    
    func fetchFilter(_ isIncluded: ((Query<FavoriteStory>) -> Query<Bool>)) -> Results<FavoriteStory>? {
        return realm?.objects(FavoriteStory.self).where { isIncluded($0) }
    }
    
    func objectByPrimaryKey<KeyType>(primaryKey: KeyType) -> FavoriteStory? {
        return realm?.object(ofType: FavoriteStory.self, forPrimaryKey: primaryKey)
    }
    
    func create(_ item: FavoriteStory, errorHandler: () -> Void) {
        do {
            try realm?.write {
                realm?.add(item)
            }
        } catch {
            errorHandler()
        }
    }
    
    func update(_ item: FavoriteStory, errorHandler: () -> Void) {
        do {
            try realm?.write {
                realm?.create(
                    FavoriteStory.self,
                    value: item,
                    update: .modified
                )
            }
        } catch {
            errorHandler()
        }
    }
    
    func delete(_ item: FavoriteStory, errorHandler: () -> Void) {
        do {
            try realm?.write {
                realm?.delete(item)
            }
        } catch  {
            errorHandler()
        }
    }
    
}
