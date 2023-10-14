//
//  CustomAnnotation.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/14.
//

import MapKit

final class StoryAnnotation: NSObject, MKAnnotation {
//    @objc dynamic var coordinate: CLLocationCoordinate2D
    var coordinate: CLLocationCoordinate2D
    var item: StoryItem
    
    init(coordinate: CLLocationCoordinate2D, item: StoryItem) {
        self.coordinate = coordinate
        self.item = item
    }
}
