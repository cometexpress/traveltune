//
//  FavoriteStory.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/01.
//

import Foundation
import RealmSwift

final class FavoriteStory: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var tid: String
    @Persisted var tlid: String
    @Persisted var stid: String
    @Persisted var stlid: String
    @Persisted var mapX: String
    @Persisted var mapY: String
    @Persisted var audioTitle: String
    @Persisted var script: String
    @Persisted var convertTime: String
    @Persisted var audioURL: String
    @Persisted var langCode: String
    @Persisted var imageURL: String
    @Persisted var searchKeyword: String
    @Persisted var date: Date
    
    convenience init(
        tid: String,
        tlid: String,
        stid: String,
        stlid: String,
        mapX: String,
        mapY: String,
        audioTitle: String,
        script: String,
        convertTime: String,
        audioURL: String,
        langCode: String,
        imageURL: String,
        searchKeyword: String
    ) {
        self.init()
        self.tid = tid
        self.tlid = tlid
        self.stid = stid
        self.stlid = stlid
        self.mapX = mapX
        self.mapY = mapY
        self.audioTitle = audioTitle
        self.script = script
        self.convertTime = convertTime
        self.audioURL = audioURL
        self.langCode = langCode
        self.imageURL = imageURL
        self.searchKeyword = searchKeyword
        self.date = .now
    }
}
