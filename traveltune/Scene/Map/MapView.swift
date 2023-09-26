//
//  MapView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/22.
//

import UIKit
import SnapKit

final class MapView: BaseView {
    
    lazy var scrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.backgroundColor = .clear
        view.minimumZoomScale = 1.5
        view.maximumZoomScale = 3
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private let containerView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()
    
    private let mapImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        view.image = .koreaMap.withTintColor(.koreaMapTint, renderingMode: .alwaysOriginal)
        return view
    }()
    
    private lazy var seoulButton = {
        let view = RegionButton()
        view.setRegionTitle(title: "서울")
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var gyeonggiButton = {
        let view = RegionButton()
        view.setRegionTitle(title: "경기")
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
        return view
    }()
    
    @objc func regionButtonClicked(_ sender: UIButton) {
        print(sender.titleLabel?.text)
        let numbers = [0]
        let _ = numbers[1]
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
