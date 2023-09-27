//
//  TravelSpotRepository.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/27.
//

import Foundation
import RealmSwift

final class TravelSpotRepository: RealmProtocol {
    
    typealias T = TravelSpotItem
    
    private let realm = try? Realm()
    private lazy var fileURL = self.realm?.configuration.fileURL
    
    func fetch() -> Results<TravelSpotItem>? {
        return realm?.objects(TravelSpotItem.self)
    }
    
    func fetchFilter(_ isIncluded: ((Query<TravelSpotItem>) -> Query<Bool>)) -> Results<TravelSpotItem>? {
        return realm?.objects(TravelSpotItem.self).where { isIncluded($0) }
    }
    
    func objectByPrimaryKey<ObjectId>(primaryKey: ObjectId) -> TravelSpotItem? {
        return realm?.object(ofType: TravelSpotItem.self, forPrimaryKey: primaryKey)
    }
    
    func create(_ item: TravelSpotItem, errorHandler: () -> Void) {
        do {
            try realm?.write {
                realm?.add(item)
            }
        } catch {
            errorHandler()
        }
    }
    
    func update(_ item: TravelSpotItem, errorHandler: () -> Void) {
        do {
            try realm?.write {
                realm?.create(
                    TravelSpotItem.self,
                    value: item,
                    update: .modified
                )
            }
        } catch {
            errorHandler()
        }
    }
    
    func delete(_ item: TravelSpotItem, errorHandler: () -> Void) {
        do {
            try realm?.write {
                realm?.delete(item)
            }
        } catch  {
            errorHandler()
        }
    }
    
}
