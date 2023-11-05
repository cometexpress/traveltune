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
        
        if let name = viewModel?.regionType.name {
            var upperName = name
            mainView.regionLabel.text = "\(upperName.firstCharUppercased()) \(Strings.Common.touristDestination)" 
        }
    }
    
    func bindViewModel() {
        guard let viewModel else { return }
        viewModel.fetchMapSpotItems()
        viewModel.state.subscribe(with: self, onNext: { owner, state in
            switch state {
            case .initValue: Void()
            case .loading: LoadingIndicator.show()
            case .success: LoadingIndicator.hide()
            case .error:
                owner.showToast(msg: Strings.ErrorMsg.errorLoadingData)
                LoadingIndicator.hide()
            }
        })
        .disposed(by: viewModel.disposeBag)
        
        viewModel.mapSpotItems
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: MapSpotCell.identifier, cellType: MapSpotCell.self)) { (row, element, cell) in
                cell.configCell(row: element)
            }
            .disposed(by: viewModel.disposeBag)
        
        // didSelectItemAt
        Observable.zip(mainView.collectionView.rx.itemSelected, mainView.collectionView.rx.modelSelected(MapSpotItem.self))
            .subscribe(with: self) { owner, selectedItem in
                owner.didSelect?(selectedItem.1)
            }
            .disposed(by: viewModel.disposeBag)
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
