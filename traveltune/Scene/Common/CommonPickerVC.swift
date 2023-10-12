//
//  CommonPickerVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/12.
//

import UIKit
import SnapKit

final class CommonPickerVC: UIViewController {
    
    private let containerView = UIView().setup { view in
        view.backgroundColor = .background
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
    }
    private lazy var pickerView = UIPickerView().setup { view in
        view.delegate = self
        view.dataSource = self
    }
    
    private lazy var okButton = UIButton().setup { view in
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        var attString = AttributedString(Strings.Common.ok)
        attString.font = .systemFont(ofSize: 16, weight: .bold)
        var config = UIButton.Configuration.filled()
        config.attributedTitle = attString
        config.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.baseBackgroundColor = .primary
        config.baseForegroundColor = .white
        view.configuration = config
        
        view.addTarget(self, action: #selector(okButtonClicked), for: .touchUpInside)
    }
    
    var items: [String] = []
    var selectedItem: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundDim
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundClicked))
        view.addGestureRecognizer(tap)
        
        configureHierarchy()
        configureLayout()
        
        if let selectedItem , let indexPosition = items.firstIndex(of: selectedItem){
            pickerView.selectRow(indexPosition, inComponent: 0, animated: false)
        }
    }
    
    @objc private func backgroundClicked() {
        dismiss(animated: true)
    }
    
    @objc private func okButtonClicked() {
        if let selectedItem {
            NotificationCenter.default.post(
                name: .regionChange,
                object: nil,
                userInfo:  [ "region" : selectedItem]
            )
        }
        
        dismiss(animated: true)
    }
    
    private func configureHierarchy() {
        view.addSubview(containerView)
        containerView.addSubview(pickerView)
        containerView.addSubview(okButton)
    }
    
    private func configureLayout() {
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(view.snp.width).multipliedBy(0.8)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.4)
        }
        
        pickerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(containerView.snp.width).multipliedBy(0.65)
            make.top.equalToSuperview().inset(20)
        }
        
        okButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(pickerView)
            make.top.equalTo(pickerView.snp.bottom)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}

extension CommonPickerVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadComponent(component)
        selectedItem = items[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var color: UIColor = .txtDisabled
        var font: UIFont = .monospacedSystemFont(ofSize: 14, weight: .light)
        
        if row == pickerView.selectedRow(inComponent: 0) {
            color = .primary
            font = .monospacedSystemFont(ofSize: 14, weight: .bold)
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): color,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font
        ]
        
        return NSAttributedString(string: items[row], attributes: attributes)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}
