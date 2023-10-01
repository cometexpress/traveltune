//
//  MapView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/22.
//

import UIKit
import SnapKit

final class MapView: BaseView {
    
    lazy var scrollView = UIScrollView().setup { view in
        view.delegate = self
        view.backgroundColor = .clear
        view.minimumZoomScale = 1.5
        view.maximumZoomScale = 3
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
    }
    
    private lazy var containerView = UIView().setup { view in
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapTesture))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }
    
    private let mapImageView = UIImageView().setup { view in
        view.contentMode = .scaleAspectFit
        view.image = .koreaMap.withTintColor(.koreaMapTint, renderingMode: .alwaysOriginal)
    }
    
    private lazy var seoulButton = RegionButton().setup { view in
        view.setRegionTitle(title: Strings.Region.seoul.uppercased())
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var gyeonggiButton = RegionButton().setup { view in
        view.setRegionTitle(title: Strings.Region.gyeonggi.uppercased())
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    
    @objc private func doubleTapTesture() {
        if scrollView.zoomScale < 3 {
            scrollView.setZoomScale(3, animated: true)
        } else {
            scrollView.setZoomScale(1.5, animated: true)
        }
    }
    
    @objc func regionButtonClicked(_ sender: UIButton) {
        print(sender.titleLabel?.text)
    }
    
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(mapImageView)
        containerView.addSubview(seoulButton)
        containerView.addSubview(gyeonggiButton)
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        containerView.snp.makeConstraints { make in
            make.size.equalTo(scrollView)
        }
        
        mapImageView.snp.makeConstraints { make in
            make.width.equalTo(320)
            make.height.equalTo(420)
            make.center.equalTo(containerView)
        }
        
        seoulButton.snp.makeConstraints { make in
            make.top.equalTo(mapImageView.snp.top).offset(100)
            make.leading.equalTo(mapImageView.snp.leading).offset(100)
        }
        
        gyeonggiButton.snp.makeConstraints { make in
            make.top.equalTo(mapImageView.snp.top).offset(70)
            make.leading.equalTo(mapImageView.snp.leading).offset(90)
        }
    }
}

extension MapView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return containerView
    }
}
