//
//  BaseViewController.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/22.
//

import UIKit

class BaseViewController<T: BaseView>: UIViewController {
    
    var isShowDeinit: Bool { false }
    
    var mainView: T {
        return view as! T
    }
    
    override func loadView() {
        view = T.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    func configureVC() { }
    
    deinit {
        if isShowDeinit {
            print("[",String(describing: type(of: self)), "] / [deinit]")
        }
    }
}
