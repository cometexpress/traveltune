//
//  MapFloatingPanelView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/11.
//

import UIKit
import SnapKit

final class MapFloatingPanelView: BaseView {
    
    override var viewBg: UIColor { .backgroundPlaceholder }
    
    weak var mapFloatingPanelProtocol: MapFloatingPanelProtocol?
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).setup { view in
        view.showsVerticalScrollIndicator = false
        view.register(
            MapSpotCell.self,
            forCellWithReuseIdentifier: MapSpotCell.identifier
        )
    }
    
    var regionLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 18, weight: .bold)
        view.textColor = .txtPrimary
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.5
    }
    
    private lazy var moveMapView = CircleImageButtonView().setup { view in
        view.setView(backgroundColor: .backgroundButton, image: .enterMap)
        let tap = UITapGestureRecognizer(target: self, action: #selector(moveMapClicked))
        view.addGestureRecognizer(tap)
    }
    
    @objc func moveMapClicked() {
        mapFloatingPanelProtocol?.moveMapButtonClicked()
    }
    
    override func configureHierarchy() {
        [regionLabel,collectionView,moveMapView].forEach(addSubview(_:))
    }
    
    override func configureLayout() {
        regionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(moveMapView.snp.leading).offset(8)
        }
        
        moveMapView.snp.makeConstraints { make in
            make.top.equalTo(regionLabel)
            make.bottom.equalTo(regionLabel)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(38)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(regionLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        // 비율 계산해서 디바이스 별로 UI 설정
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let count: CGFloat = 2
        let width: CGFloat = UIScreen.main.bounds.width - (spacing * (count + 1)) // 디바이스 너비 계산
        
        layout.itemSize = CGSize(width: width / count, height: width / count)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)  // 컨텐츠가 잘리지 않고 자연스럽게 표시되도록 여백설정
        layout.minimumLineSpacing = spacing         // 셀과셀 위 아래 최소 간격
        layout.minimumInteritemSpacing = spacing    // 셀과셀 좌 우 최소 간격
        return layout
    }
}
