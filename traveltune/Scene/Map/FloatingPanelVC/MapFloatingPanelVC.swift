//
//  MapFloatingPanelVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/10.
//

import UIKit
import SnapKit

final class MapFloatingPanelVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var selectedRegionType: RegionType?
    var didSelect: ((String) -> Void)?
    
    private let items: [String] = [
        "option A",
        "option B",
        "option C",
        "option D",
        "option E",
        "option F",
        "option G"
    ]
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).setup { view in
        view.delegate = self
        view.dataSource = self
        view.showsVerticalScrollIndicator = false
        view.register(
            MapSpotCell.self,
            forCellWithReuseIdentifier: MapSpotCell.identifier
        )
    }
    
    private var regionLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 16, weight: .bold)
        view.textColor = .txtPrimary
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [regionLabel,collectionView].forEach(view.addSubview(_:))
        
        regionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(regionLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        if let name = selectedRegionType?.name {
            var upperName = name
            regionLabel.text = upperName.firstCharUppercased()
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapSpotCell.identifier, for: indexPath) as? MapSpotCell else {
            return UICollectionViewCell()
        }

        cell.configCell(row: items[indexPath.item])
        cell.backgroundColor = .link
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelect?(items[indexPath.item])
    }

}
