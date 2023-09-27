//
//  RealmProtocol.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/27.
//

import Foundation
import RealmSwift

protocol RealmProtocol: AnyObject {
    associatedtype T: Object
    func fetch() -> Results<T>?
    func fetchFilter(_ isIncluded: ((Query<T>) -> Query<Bool>)) -> Results<T>?
    func objectByPrimaryKey<KeyType>(primaryKey: KeyType) -> T?
    func create(_ item: T, errorHandler: () -> Void)
    func update(_ item: T, errorHandler: () -> Void)
    func delete(_ item: T, errorHandler: () -> Void)
}
