//
//  UICollectionFlowLayout+Extension.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/28.
//

import UIKit

extension UICollectionViewFlowLayout {
    
    public func collectionViewLayout(
        scrollDirection: UICollectionView.ScrollDirection = .vertical,
        itemSize: CGSize,
        sectionInset: UIEdgeInsets,
        minimumLineSpacing: CGFloat,
        minimumInteritemSpacing: CGFloat
    ) -> UICollectionViewFlowLayout {
        return UICollectionViewFlowLayout().setup { view in
            view.scrollDirection = scrollDirection
            view.itemSize = itemSize
            view.sectionInset = sectionInset
            view.minimumLineSpacing = minimumLineSpacing
            view.minimumInteritemSpacing = minimumInteritemSpacing
        }
    }
}
