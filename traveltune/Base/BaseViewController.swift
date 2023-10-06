//
//  BaseViewController.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/22.
//

import UIKit

typealias BaseViewController<T: BaseView, U: BaseViewModel> = ViewController<T, U> & BaseViewContollerProtocol

protocol BaseViewContollerProtocol {
    func bindViewModel()
    func configureVC()
}

class ViewController<T: BaseView, U: BaseViewModel>: UIViewController {
    
    var isShowDeinit: Bool { false }
    
    var mainView: T {
        return view as! T
    }
    
    var viewModel: U? = nil
    
    init(viewModel: U?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    init?(coder: NSCoder, viewModel: U) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = T.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        if isShowDeinit {
            print("[",String(describing: type(of: self)), "] / [deinit]")
        }
    }
}
