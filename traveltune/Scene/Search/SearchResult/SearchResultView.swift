//
//  SearchResultView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/03.
//

import UIKit

final class SearchResultView: BaseView {
    
    lazy var naviBarSearchTextField = SearchTextField().setup { view in
        let width = UIScreen.main.bounds.width - 80
        view.frame = .init(x: 0, y: 0, width: width, height: 40)
        view.returnKeyType = .search
        view.addDoneOnKeyboardWithTarget(self, action: #selector(toolBarDoneClicked), titleText: nil)
        //        view.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(keyboardDoneClicked))
        view.delegate = self
    }
    
    @objc private func toolBarDoneClicked() {
        naviBarSearchTextField.resignFirstResponder()
    }
    
    override func configureHierarchy() {
        
    }
    
    override func configureLayout() {
        
    }
}

extension SearchResultView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("키보드 검색 버튼 클릭")
        return true
    }
}
