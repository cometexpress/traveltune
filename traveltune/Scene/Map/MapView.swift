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
        view.setRegionTitle(title: Strings.Region.seoul.firstCharUppercased())
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var gyeonggiButton = RegionButton().setup { view in
        view.setRegionTitle(title: Strings.Region.gyeonggi.firstCharUppercased())
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var incheonButton = RegionButton().setup { view in
        view.setRegionTitle(title: Strings.Region.incheon.firstCharUppercased())
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var gangwonButton = RegionButton().setup { view in
        view.setRegionTitle(title: Strings.Region.gangwon.firstCharUppercased())
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var chungbukButton = RegionButton().setup { view in
        view.setRegionTitle(title: Strings.Region.chungbuk.firstCharUppercased())
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var chungnamButton = RegionButton().setup { view in
        view.setRegionTitle(title: Strings.Region.chungnam.firstCharUppercased())
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var sejongButton = RegionButton().setup { view in
        view.setRegionTitle(title: Strings.Region.sejong.firstCharUppercased())
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var daejeonButton = RegionButton().setup { view in
        view.setRegionTitle(title: Strings.Region.daejeon.firstCharUppercased())
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var gyeongbukButton = RegionButton().setup { view in
        view.setRegionTitle(title: Strings.Region.gyeongbuk.firstCharUppercased())
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var gyeongnamButton = RegionButton().setup { view in
        view.setRegionTitle(title: Strings.Region.gyeongnam.firstCharUppercased())
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var daeguButton = RegionButton().setup { view in
        view.setRegionTitle(title: Strings.Region.daegu.firstCharUppercased())
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var ulsanButton = RegionButton().setup { view in
        view.setRegionTitle(title: Strings.Region.ulsan.firstCharUppercased())
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var busanButton = RegionButton().setup { view in
        view.setRegionTitle(title: Strings.Region.busan.firstCharUppercased())
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var jeonbukButton = RegionButton().setup { view in
        view.setRegionTitle(title: Strings.Region.jeonbuk.firstCharUppercased())
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var jeonnamButton = RegionButton().setup { view in
        view.setRegionTitle(title: Strings.Region.jeonnam.firstCharUppercased())
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var gwangjuButton = RegionButton().setup { view in
        view.setRegionTitle(title: Strings.Region.gwangju.firstCharUppercased())
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var jejuButton = RegionButton().setup { view in
        view.setRegionTitle(title: Strings.Region.jeju.firstCharUppercased())
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
        containerView.addSubview(incheonButton)
        containerView.addSubview(gangwonButton)
        containerView.addSubview(chungbukButton)
        containerView.addSubview(chungnamButton)
        containerView.addSubview(sejongButton)
        containerView.addSubview(daejeonButton)
        containerView.addSubview(gyeongbukButton)
        containerView.addSubview(gyeongnamButton)
        containerView.addSubview(daeguButton)
        containerView.addSubview(ulsanButton)
        containerView.addSubview(busanButton)
        containerView.addSubview(jeonbukButton)
        containerView.addSubview(jeonnamButton)
        containerView.addSubview(gwangjuButton)
        containerView.addSubview(jejuButton)
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
            make.leading.equalTo(mapImageView.snp.leading).offset(105)
            make.top.equalTo(mapImageView.snp.top).offset(100)
        }
        
        gyeonggiButton.snp.makeConstraints { make in
            make.leading.equalTo(mapImageView.snp.leading).offset(90)
            make.top.equalTo(mapImageView.snp.top).offset(70)
        }
        
        incheonButton.snp.makeConstraints { make in
            make.leading.equalTo(mapImageView.snp.leading).offset(56)
            make.top.equalTo(mapImageView.snp.top).offset(116)
        }
        
        gangwonButton.snp.makeConstraints { make in
            make.leading.equalTo(mapImageView.snp.leading).offset(199)
            make.top.equalTo(mapImageView.snp.top).offset(86)
        }
        
        chungbukButton.snp.makeConstraints { make in
            make.leading.equalTo(mapImageView.snp.leading).offset(144)
            make.top.equalTo(mapImageView.snp.top).offset(136)
        }
        
        chungnamButton.snp.makeConstraints { make in
            make.leading.equalTo(mapImageView.snp.leading).offset(65)
            make.top.equalTo(mapImageView.snp.top).offset(176)
        }
     
        sejongButton.snp.makeConstraints { make in
            make.leading.equalTo(mapImageView.snp.leading).offset(129)
            make.top.equalTo(mapImageView.snp.top).offset(164)
        }
        
        daejeonButton.snp.makeConstraints { make in
            make.leading.equalTo(mapImageView.snp.leading).offset(124)
            make.top.equalTo(mapImageView.snp.top).offset(192)
        }
        
        gyeongbukButton.snp.makeConstraints { make in
            make.leading.equalTo(mapImageView.snp.leading).offset(228)
            make.top.equalTo(mapImageView.snp.top).offset(176)
        }
        
        gyeongnamButton.snp.makeConstraints { make in
            make.leading.equalTo(mapImageView.snp.leading).offset(164)
            make.top.equalTo(mapImageView.snp.top).offset(261)
        }
        
        daeguButton.snp.makeConstraints { make in
            make.leading.equalTo(mapImageView.snp.leading).offset(184)
            make.top.equalTo(mapImageView.snp.top).offset(221)
        }
        
        ulsanButton.snp.makeConstraints { make in
            make.leading.equalTo(mapImageView.snp.leading).offset(239)
            make.top.equalTo(mapImageView.snp.top).offset(245)
        }
        
        busanButton.snp.makeConstraints { make in
            make.leading.equalTo(mapImageView.snp.leading).offset(219)
            make.top.equalTo(mapImageView.snp.top).offset(283)
        }
        
        jeonbukButton.snp.makeConstraints { make in
            make.leading.equalTo(mapImageView.snp.leading).offset(80)
            make.top.equalTo(mapImageView.snp.top).offset(229)
        }
        
        jeonnamButton.snp.makeConstraints { make in
            make.leading.equalTo(mapImageView.snp.leading).offset(54)
            make.top.equalTo(mapImageView.snp.top).offset(311)
        }
        
        gwangjuButton.snp.makeConstraints { make in
            make.leading.equalTo(mapImageView.snp.leading).offset(96)
            make.top.equalTo(mapImageView.snp.top).offset(277)
        }
        
        jejuButton.snp.makeConstraints { make in
            make.leading.equalTo(mapImageView.snp.leading).offset(93)
            make.top.equalTo(mapImageView.snp.top).offset(359)
        }
    }
}

extension MapView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return containerView
    }
}
