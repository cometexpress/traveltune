//
//  LocalThemeStoryRepository.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/01.
//

import Foundation
import RealmSwift

final class LocalThemeStoryRepository: RealmProtocol {
    
    typealias T = StoryItem
    
    private let realm = try? Realm()
    
    func fetch() -> Results<StoryItem>? {
        return realm?.objects(StoryItem.self)
    }
    
    func fetchFilter(_ isIncluded: ((Query<StoryItem>) -> Query<Bool>)) -> Results<StoryItem>? {
        return realm?.objects(StoryItem.self).where { isIncluded($0) }
    }
    
    func objectByPrimaryKey<ObjectId>(primaryKey: ObjectId) -> StoryItem? {
        return realm?.object(ofType: StoryItem.self, forPrimaryKey: primaryKey)
    }
    
    func create(_ item: StoryItem, errorHandler: () -> Void) {
        do {
            try realm?.write {
                realm?.add(item)
            }
        } catch {
            errorHandler()
        }
    }
    
    // 리스트 한번에 추가하기
    func createAll(_ items: [StoryItem], completionHandler: () -> Void) {
        do {
            try realm?.write {
                realm?.add(items)
                completionHandler()
            }
        } catch {
            completionHandler()
        }
    }
    
    func update(_ item: StoryItem, errorHandler: () -> Void) {
        do {
            try realm?.write {
                realm?.create(
                    StoryItem.self,
                    value: item,
                    update: .modified
                )
            }
        } catch {
            errorHandler()
        }
    }
    
    func delete(_ item: StoryItem, errorHandler: () -> Void) {
        do {
            try realm?.write {
                realm?.delete(item)
            }
        } catch  {
            errorHandler()
        }
    }
    
    func deleteAll(completionHandler: (Bool) -> Void) {
        do {
            try realm?.write {
                let allTravelSpot = realm?.objects(StoryItem.self)
                realm?.delete(allTravelSpot!)
                completionHandler(true)
            }
        } catch  {
            completionHandler(false)
        }
    }
}
