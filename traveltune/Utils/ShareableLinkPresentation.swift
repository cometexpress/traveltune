//
//  ShareableLinkPresentation.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/10.
//

import UIKit
import LinkPresentation

final class ShareableLinkPresentation: NSObject, UIActivityItemSource {
    
    private let title: String
    private let shareURL: URL?
    private let imgURL: URL?
    
    init(title: String, shareURL: URL? = nil, imgURL: URL?) {
        self.title = title
        self.shareURL = shareURL
        self.imgURL = imgURL
    }
    
//    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
//        return title
//    }
//    
//    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
//        return shareURL
//    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return UIImage() // an empty UIImage is sufficient to ensure share sheet shows right actions
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return imgURL
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title
        metadata.iconProvider = NSItemProvider(object: UIImage(named: "logo")!)
        metadata.originalURL = shareURL
        metadata.url = imgURL
        metadata.imageProvider = NSItemProvider.init(contentsOf: imgURL)
        
//        if let shareURL {
//            metadata.originalURL = shareURL
//            metadata.url = shareURL
//        }
        
//        metadata.imageProvider = NSItemProvider(contentsOf: imageURL)
//                metadata.imageProvider = NSItemProvider.init(
//                        contentsOf:Bundle.main.url(forResource: "11253", withExtension: "jpg"))
        return metadata
    }
    
    //    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
    //        if activityType == .airDrop || activityType == .addToReadingList {
    //                return url
    //            } else {
    //                return shareText
    //            }
    //    }
    
    //    func activityViewController(_ activityViewController: UIActivityViewController, dataTypeIdentifierForActivityType activityType: UIActivity.ActivityType?) -> String {
    //      return UTType.png.identifier
    //    }
}
