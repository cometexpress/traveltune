//
//  MapVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/22.
//

import UIKit
import FloatingPanel

final class MapVC: BaseViewController<MapView, MapViewModel> {
    
    private lazy var fpc = FloatingPanelController(delegate: self).setup { view in
        view.isRemovalInteractionEnabled = false
        view.surfaceView.backgroundColor = .backgroundPlaceholder
        view.surfaceView.appearance.cornerRadius = 24.0
        view.surfaceView.appearance.shadows = []
        view.surfaceView.appearance.borderWidth = 1.0 / traitCollection.displayScale
        view.surfaceView.appearance.borderColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    private func layout() {
        fpc.addPanel(toParent: self)
    }
    
    var currentRegion = ""
    
    // 선택한 아이템 상세페이지로 이동시키기
    var selectItem: MapSpotItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async { [weak self] in
            self?.mainView.scrollView.setZoomScale(2, animated: true)
        }
        configureVC()
        bindViewModel()
    }
    
    func configureVC() {
        mainView.mapVCProtocol = self
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.background
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.txtPrimary,
            .font: UIFont.monospacedSystemFont(ofSize: 18, weight: .medium)
        ]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.topItem?.title = Strings.TabMap.title
        
        layout()
        fpc.hide(animated: true)
    }
    
    func bindViewModel() {
        
    }
}

class MapFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip

    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
        .full: FloatingPanelLayoutAnchor(absoluteInset: 56.0, edge: .top, referenceGuide: .safeArea),
        .half: FloatingPanelLayoutAnchor(absoluteInset: 262.0, edge: .bottom, referenceGuide: .safeArea),
        .tip: FloatingPanelLayoutAnchor(absoluteInset: 25.0 + 44.0, edge: .bottom, referenceGuide: .safeArea),
    ]

    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.0
    }
}

extension MapVC: FloatingPanelControllerDelegate {
    
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
//        print(fpc)
    }
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return MapFloatingPanelLayout()
    }
}

extension MapVC: MapVCProtocol {
    func regionButtonClicked(type: RegionType) {
        
        if currentRegion == type.name {
            switch fpc.state {
            case .half:
                fpc.move(to: .tip, animated: true)
            case .hidden:
                fpc.move(to: .tip, animated: true)
            case .tip:
                fpc.move(to: .tip, animated: true)
            default: break
            }
        } else {
            
            // 지역에 데이터 불러올 떄
            LoadingIndicator.show()
            let contentVC = MapFloatingPanelVC(
                viewModel: MapFloatingPanelViewModel(
                    regionType: type,
                    travelSpotRepository: TravelSpotRepository(),
                    storyRepository: StoryRepository()
                )
            )
            contentVC.didSelect = { [weak self] item in
                self?.selectItem = item
                
                let vc = DetailMapSpotVC(viewModel: DetailMapSpotViewModel(localFavoriteStoryRepository: LocalFavoriteStoryRepository()))
                vc.modalPresentationStyle = .fullScreen
                vc.viewModel?.mapSpotItem = item
                self?.present(vc, animated: false)
            }
            fpc.set(contentViewController: contentVC)
            fpc.track(scrollView: contentVC.mainView.collectionView)
            
            fpc.move(to: .half, animated: true)
        }
        currentRegion = type.name
        
//        switch fpc.state {
//        case .half:
//            fpc.move(to: .full, animated: true)
//        case .hidden:
//            fpc.move(to: .tip, animated: true)
//        case .tip:
//            fpc.move(to: .half, animated: true)
//        default: break
//        }
    }
}

