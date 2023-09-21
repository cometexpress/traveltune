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
    let testImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bg
        testImageView.image = .koreaMap
        
        view.addSubview(testLabel)
        view.addSubview(testImageView)
        
        testLabel.textColor = .primary
        testLabel.text = Strings.Test.test
        testLabel.font = .monospacedSystemFont(ofSize: 40, weight: .bold)
        testLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.centerX.equalToSuperview()
        }
        
        testImageView.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.center.equalToSuperview()
        }
        
    }


}

