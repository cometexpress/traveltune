//
//  SearchResultTabTravelSpotView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/04.
//

import UIKit
import SnapKit

final class SearchResultTabTravelSpotView: BaseView {
    
    private let emptyLabel = UILabel().setup { view in
        view.textColor = .txtDisabled
        view.font = .monospacedSystemFont(ofSize: 16, weight: .medium)
        view.text = Strings.Common.searchNoData
        view.textAlignment = .center
    }
    
    // 데이터 있을 때
    private let containerView = UIView()
    
    override func configureHierarchy() {
        addSubview(containerView)
        addSubview(emptyLabel)
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalTo(safeAreaLayoutGuide)
        }
    }
    
}
