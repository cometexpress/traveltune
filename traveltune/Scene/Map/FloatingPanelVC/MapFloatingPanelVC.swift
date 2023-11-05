//
//  MapFloatingPanelVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/10.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

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
        guard let viewModel else { return }
        // 지도상세 개발 중 주석처리
        viewModel.fetchMapSpotItems()
        viewModel.state.subscribe(with: self, onNext: { owner, state in
            switch state {
            case .initValue: Void()
            case .loading: LoadingIndicator.show()
            case .success(let spotItems):
                owner.mapSpotItems = spotItems
                LoadingIndicator.hide()
            case .error:
                owner.showToast(msg: Strings.ErrorMsg.errorLoadingData)
                LoadingIndicator.hide()
            }
        })
        .disposed(by: viewModel.disposeBag)
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
        guard let regionType = self.viewModel?.regionType else { return }
        let vc = DetailRegionMapVC(
            viewModel: DetailRegionMapViewModel(
                regionType: regionType,
                storyRepository: StoryRepository()
            )
        )
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
