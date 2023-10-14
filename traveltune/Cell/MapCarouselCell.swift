//
//  MapCarouselCell.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/14.
//

import UIKit
import SnapKit

final class MapCarouselCell: BaseCollectionViewCell<StoryItem> {
    
    private let containerView = UIView().setup { view in
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.backgroundColor = .backgroundPlaceholder
    }
    
    private let thumbImageView = ThumbnailImageView(frame: .zero).setup { view in
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    private let textContainerView = UIView()
    
    private let titleLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 14, weight: .bold)
        view.textColor = .txtPrimary
    }
    
    private let scriptLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 11, weight: .light)
        view.numberOfLines = 2
        view.textColor = .txtSecondary
    }
    
    private let locationImageView = UIImageView().setup { view in
        view.image = .location.withRenderingMode(.alwaysTemplate)
        view.tintColor = .primary
    }
    
    private let distanceLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
        view.textColor = .txtSecondary
        view.textAlignment = .right
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbImageView.image = .defaultImg
    }
    
    override func configureHierarchy() {
        contentView.addSubview(containerView)
        contentView.addSubview(textContainerView)
        containerView.addSubview(thumbImageView)
        textContainerView.addSubview(titleLabel)
        textContainerView.addSubview(scriptLabel)
        textContainerView.addSubview(locationImageView)
        textContainerView.addSubview(distanceLabel)
        
        titleLabel.text = "row.audioTitle"
        scriptLabel.text = "row.script.trimmingCharacters(in: .whitespacesAndNewlines)"
        distanceLabel.text = "10.0km"
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        thumbImageView.snp.makeConstraints { make in
            make.width.equalTo(containerView.snp.width).multipliedBy(0.5)
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
        }

        textContainerView.snp.makeConstraints { make in
            make.leading.equalTo(thumbImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.verticalEdges.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        scriptLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview()
        }
        
        locationImageView.snp.makeConstraints { make in
            make.width.equalTo(11)
            make.height.equalTo(14)
            make.centerY.equalTo(distanceLabel)
            make.trailing.equalTo(distanceLabel.snp.leading).offset(-6)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.trailing.equalToSuperview()
        }
    }
    
    override func configCell(row: StoryItem) {
        thumbImageView.addImage(url: row.imageURL)
        titleLabel.text = row.audioTitle
        scriptLabel.text = row.script.replacingOccurrences(of: "  ", with: " ").trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func calculationDistance(currentLat: Double, currentLng: Double) {
        // TODO: 현재 위치와 지금 위치 거리 계산해서 보여주기
        distanceLabel.text = "계산된 거리 km"
    }
}
