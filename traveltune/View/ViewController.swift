//
//  ViewController.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/21.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    let testLabel = UILabel()
    let testImageView = {
        let view = UIImageView()
        view.image = .koreaMap.withTintColor(.koreaMapTint, renderingMode: .alwaysOriginal)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        view.addSubview(testLabel)
        view.addSubview(testImageView)
        
        testLabel.textColor = .primary
//        testLabel.text = Strings.Test.test
        testLabel.font = .monospacedSystemFont(ofSize: 40, weight: .bold)
        testLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.centerX.equalToSuperview()
        }
        
        testImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }


}

