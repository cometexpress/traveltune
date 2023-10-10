//
//  MapFloatingPanelVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/10.
//

import UIKit
import SnapKit

final class MapFloatingPanelVC: BaseViewController<MapFloatingPanelView, MapFloatingPanelViewModel>, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var selectedRegionType: RegionType?
    var didSelect: ((MapSpotItem) -> Void)?
    
    private var mapSpotItems: [MapSpotItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        bindViewModel()
    }
    
    func configureVC() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        
        if let name = selectedRegionType?.name {
            var upperName = name
            mainView.regionLabel.text = upperName.firstCharUppercased()
        }
    }
    
    func bindViewModel() {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapSpotCell.identifier, for: indexPath) as? MapSpotCell else {
            return UICollectionViewCell()
        }

        cell.configCell(row: mapSpotItems[indexPath.item])
        cell.backgroundColor = .link
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mapSpotItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelect?(mapSpotItems[indexPath.item])
    }

}
