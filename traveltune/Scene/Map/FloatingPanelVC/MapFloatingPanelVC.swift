//
//  MapFloatingPanelVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/10.
//

import UIKit
import SnapKit

final class MapFloatingPanelVC: BaseViewController<MapFloatingPanelView, MapFloatingPanelViewModel> {
    
    var didSelect: ((MapSpotItem) -> Void)?
    
    private var mapSpotItems: [MapSpotItem] = [] {
        didSet {
            mainView.collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        bindViewModel()
    }
    
    func configureVC() {
        mainView.mapFloatingPanelProtocol = self
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        
        if let name = viewModel?.regionType.name {
            var upperName = name
            mainView.regionLabel.text = "\(upperName.firstCharUppercased()) \(Strings.Common.touristDestination)" 
        }
    }
    
    func bindViewModel() {
        viewModel?.fetchMapSpotItems()
        viewModel?.state.bind { [weak self] state in
            switch state {
            case .initValue: Void()
            case .loading:
                LoadingIndicator.show()
            case .success(let data):
                self?.mapSpotItems = data.sorted(by: {$0.travelSpot.imageURL > $1.travelSpot.imageURL})
                LoadingIndicator.hide()
            case .error(let msg):
                self?.showToast(msg: Strings.ErrorMsg.errorLoadingData)
                LoadingIndicator.hide()
            }
        }
    }
}

extension MapFloatingPanelVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapSpotCell.identifier, for: indexPath) as? MapSpotCell else {
            return UICollectionViewCell()
        }
        cell.configCell(row: mapSpotItems[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mapSpotItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: 맵 상세화면으로 이동시키기
        didSelect?(mapSpotItems[indexPath.item])
    }
}

extension MapFloatingPanelVC: MapFloatingPanelProtocol {
    func moveMapButtonClicked() {
        // TODO: 맵킷 화면으로 이동시키기
        print("맵킷 화면으로 이동시키기")
    }
}
