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
                self?.mapSpotItems = data
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
        didSelect?(mapSpotItems[indexPath.item])
    }
}

extension MapFloatingPanelVC: MapFloatingPanelProtocol {
    
    func moveMapButtonClicked() {
        let vc = DetailRegionMapVC(viewModel: DetailRegionMapViewModel())
        vc.viewModel?.regionType = self.viewModel?.regionType
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
