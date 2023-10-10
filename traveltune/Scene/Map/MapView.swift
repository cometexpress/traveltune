//
//  MapView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/22.
//

import UIKit
import SnapKit

struct RegionButtonItems {
    let button: UIButton
    let isSelected: Bool
}

final class MapView: BaseView {
    
    weak var mapVCProtocol: MapVCProtocol?
    
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
    
    private lazy var seoulButton = RegionButton(title: Strings.Region.seoul.firstCharUppercased(), type: .seoul).setup { view in
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var gyeonggiButton = RegionButton(title: Strings.Region.gyeonggi.firstCharUppercased(), type: .gyeonggi).setup { view in
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var incheonButton = RegionButton(title: Strings.Region.incheon.firstCharUppercased(), type: .incheon).setup { view in
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var gangwonButton = RegionButton(title: Strings.Region.gangwon.firstCharUppercased(), type: .gangwon).setup { view in
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var chungbukButton = RegionButton(title: Strings.Region.chungbuk.firstCharUppercased(), type: .chungbuk).setup { view in
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var chungnamButton = RegionButton(title: Strings.Region.chungnam.firstCharUppercased(), type: .chungnam).setup { view in
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var sejongButton = RegionButton(title: Strings.Region.sejong.firstCharUppercased(), type: .sejong).setup { view in
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var daejeonButton = RegionButton(title: Strings.Region.daejeon.firstCharUppercased(), type: .daejeon).setup { view in
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var gyeongbukButton = RegionButton(title: Strings.Region.gyeongbuk.firstCharUppercased(), type: .gyeongbuk).setup { view in
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var gyeongnamButton = RegionButton(title: Strings.Region.gyeongnam.firstCharUppercased(), type: .gyeongnam).setup { view in
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var daeguButton = RegionButton(title: Strings.Region.daegu.firstCharUppercased(), type: .daegu).setup { view in
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var ulsanButton = RegionButton(title: Strings.Region.ulsan.firstCharUppercased(), type: .ulsan).setup { view in
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var busanButton = RegionButton(title: Strings.Region.busan.firstCharUppercased(), type: .busan).setup { view in
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var jeonbukButton = RegionButton(title: Strings.Region.jeonbuk.firstCharUppercased(), type: .jeonbuk).setup { view in
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var jeonnamButton = RegionButton(title: Strings.Region.jeonnam.firstCharUppercased(), type: .jeonnam).setup { view in
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var gwangjuButton = RegionButton(title: Strings.Region.gwangju.firstCharUppercased(), type: .gwangju).setup { view in
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }
    
    private lazy var jejuButton = RegionButton(title: Strings.Region.jeju.firstCharUppercased(), type: .jeju).setup { view in
        view.addTarget(self, action: #selector(regionButtonClicked( _:)), for: .touchUpInside)
    }

    private lazy var arrRegionButton = [
        seoulButton,gyeonggiButton,incheonButton,gangwonButton,chungbukButton,chungbukButton,
        chungnamButton,sejongButton,daejeonButton,gyeongbukButton,gyeongnamButton,daeguButton,
        ulsanButton,busanButton,jeonbukButton,jeonnamButton,gwangjuButton,jejuButton
    ]
    
    private lazy var deviceCenterX = self.frame.width / 2
    private lazy var deviceCenterY = self.frame.height / 2
    
    @objc private func doubleTapTesture() {
        if scrollView.zoomScale < 3 {
            scrollView.setZoomScale(3, animated: true)
        } else {
            scrollView.setZoomScale(1.5, animated: true)
        }
    }
    
    @objc func regionButtonClicked(_ sender: RegionButton) {
        guard let name = sender.titleLabel?.text else { return }
        print(name)
        mapVCProtocol?.regionButtonClicked(regionName: name)
        for btn in arrRegionButton {
            if btn == sender {
                btn.isSelected = true
                btn.selectedBackground()
                
                /**
                 1. 현재 중심 위치 좌표
                 2. 현재 선택한 버튼의 위치 좌표
                 3. 1, 2번을 이용해서 계산..?
                 */
                
//                print("scrollView center x = ", scrollView.contentSize.width / 2)
//                print("scrollView center y = ", scrollView.contentSize.height / 2)
//                
//                print("device center x = ", deviceCenterX)
//                print("device center y = ", deviceCenterY)
//                
//                print("maxX = ", btn.frame.maxX)
//                print("maxY = ", btn.frame.maxY)
//                
//                print("midX = ", btn.frame.midX)
//                print("midY = ", btn.frame.midY)
//                
//                print("minX = ", btn.frame.minX)
//                print("minY = ", btn.frame.minY)
                
                
//                scrollView.setZoomScale(1.5, animated: true)
//                scrollView.setContentOffset(.init(x: scrollView.contentOffset.x + btn.frame.midX, y: scrollView.contentOffset.y + btn.frame.midY), animated: true)
                
//                let offsetX = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0)
//                let offsetY = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0)
//                btn.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY)
                
            } else {
                btn.isSelected = false
                btn.defaultBackground()
            }
        }
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
    }
}
