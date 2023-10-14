//
//  StoryAnnotation.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/14.
//

import MapKit

final class StoryAnnotation: MKPointAnnotation {

    var item: StoryItem
    
    init(item: StoryItem) {
        self.item = item
    }
}
