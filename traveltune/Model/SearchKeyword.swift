//
//  SearchKeyword.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/04.
//

import Foundation
import RealmSwift

final class SearchKeyword: Object {
    @Persisted(primaryKey: true) var _id = ObjectId.generate().stringValue
    @Persisted var text: String
    @Persisted var date: Date
    
    convenience init(text: String) {
        self.init()
        self.text = text
        self.date = .now
    }
}
