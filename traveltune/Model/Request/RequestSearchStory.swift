//
//  RequestSearchStory.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/05.
//

import Foundation

struct RequestSearchStory: Encodable {
    let keyword: String
    let pageNo: String    
    let numOfRows: String
}
