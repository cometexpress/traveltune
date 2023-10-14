//
//  DetailRegionMapView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/12.
//

import UIKit
import MapKit
import SnapKit

final class DetailRegionMapView: BaseView {
    
    weak var detailRegionMapViewProtocol: DetailRegionMapVCProtocol?
    
    var currentIndex: CGFloat = 0
    var isOneStepPaging = true
    
    private let deviceWidth: CGFloat = UIScreen.main.bounds.width
    private let deviceHeight: CGFloat = UIScreen.main.bounds.height
    
    private lazy var cellWidth = floor(deviceWidth * 0.82)
    private lazy var cellHeight = floor(deviceHeight * 0.15)
    
    var selectedStoryItems: [StoryItem] = [] {
        didSet {
            bottomCollectionView.reloadData()
            bottomCollectionView.isHidden = selectedStoryItems.isEmpty
        }
    }
    
    private var currentLat: Double = 0
    private var currentLng: Double = 0
    
    let mapView = ExcludeMapView().setup { view in
        view.showsUserLocation = true       // 유저 위치
        view.setCameraZoomRange(.init(maxCenterCoordinateDistance: 1000000), animated: true)
        view.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.identifier)
        view.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    private lazy var currentMyLocationView = CircleImageButtonView().setup { view in
        view.setView(backgroundColor: .primary, image: .scope)
        let tap = UITapGestureRecognizer(target: self, action: #selector(currentMyLocationClicked))
        view.addGestureRecognizer(tap)
    }
    
    lazy var selectRegionButton = UIButton().setup { view in
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.addTarget(self, action: #selector(selectRegionButtonClicked(_ :)), for: .touchUpInside)
    }
    
    lazy var bottomCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout()).setup { view in
        view.delegate = self
        view.dataSource = self
        view.showsHorizontalScrollIndicator = false
        view.bounces = false
        // 스크롤 시 빠르게 감속 되도록 설정
        view.decelerationRate = .fast
        view.isHidden = true
        view.register(MapCarouselCell.self, forCellWithReuseIdentifier: MapCarouselCell.identifier)
        
        let insetX = (deviceWidth - cellWidth) / 2.0
        view.contentInset = .init(top: 0, left: insetX, bottom: 0, right: insetX)
    }
    
    @objc private func currentMyLocationClicked() {
        detailRegionMapViewProtocol?.currentLocationClicked()
    }
    
    @objc private func selectRegionButtonClicked(_ sender: UIButton) {
        detailRegionMapViewProtocol?.selectRegionButtonClicked(item: (sender.titleLabel?.text)!)
    }
    
    func updateButtonTitle(title: String) {
        var attString = AttributedString(title)
        attString.font = .systemFont(ofSize: 16, weight: .semibold)
        var config = UIButton.Configuration.filled()
        config.attributedTitle = attString
        config.contentInsets = .init(top: 6, leading: 12, bottom: 6, trailing: 12)
        config.image = .chevronDown.withConfiguration(UIImage.SymbolConfiguration(pointSize: 12, weight: .light)).withTintColor(.white, renderingMode: .alwaysTemplate)
        config.imagePadding = 4
        config.imagePlacement = .trailing
        config.baseBackgroundColor = .primary
        config.baseForegroundColor = .white
        selectRegionButton.configuration = config
    }
    
    func updateUserLocation() {
        guard let userLocation = mapView.userLocation.location else {
            print("유저 위치 없음")
            return
        }
        print("유저 위치 있음")
        currentLat = userLocation.coordinate.latitude
        currentLng = userLocation.coordinate.longitude
    }
    
    override func configureHierarchy() {
        addSubview(mapView)
        addSubview(currentMyLocationView)
        addSubview(selectRegionButton)
        addSubview(bottomCollectionView)
    }
    
    override func configureLayout() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        currentMyLocationView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(44)
        }
        
        selectRegionButton.snp.makeConstraints { make in
            make.centerY.equalTo(currentMyLocationView)
            make.leading.equalToSuperview().inset(20)
        }
        
        bottomCollectionView.snp.makeConstraints { make in
            make.height.equalTo(cellHeight)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(40)
            make.horizontalEdges.equalToSuperview()
        }
    }
}

extension DetailRegionMapView {
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        return UICollectionViewFlowLayout().collectionViewLayout(
            scrollDirection: .horizontal,
            headerSize: .zero,
            itemSize: CGSize(width: cellWidth, height: cellHeight),
            sectionInset: .zero,
            minimumLineSpacing: 20,
            minimumInteritemSpacing: 0)
    }
}

extension DetailRegionMapView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedStoryItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapCarouselCell.identifier, for: indexPath) as? MapCarouselCell else {
            return UICollectionViewCell()
        }
        
        let item = selectedStoryItems[indexPath.item]
        cell.configCell(row: item)
        cell.calculationDistance(row: item, currentLat: currentLat, currentLng: currentLng)
        return cell
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
        let layout = bottomCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
        // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)
        
        // scrollView, targetContentOffset의 좌표 값으로 스크롤 방향을 알 수 있다.
        // index를 반올림하여 사용하면 item의 절반 사이즈만큼 스크롤을 해야 페이징이 된다.
        // 스크로로 방향을 체크하여 올림,내림을 사용하면 좀 더 자연스러운 페이징 효과를 낼 수 있다.
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
            roundedIndex = ceil(index)
        } else {
            roundedIndex = round(index)
        }
        
        if currentIndex > roundedIndex {
            currentIndex -= 1
            roundedIndex = currentIndex
        } else if currentIndex < roundedIndex {
            currentIndex += 1
            roundedIndex = currentIndex
        }
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}
