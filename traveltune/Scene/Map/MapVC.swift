//
//  MapVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/22.
//

import UIKit
import FloatingPanel

final class MapVC: BaseViewController<MapView, MapViewModel> {
    
    private lazy var fpc = FloatingPanelController(delegate: self).setup { view in
        let contentVC = TableViewController()
        contentVC.didSelect = { [weak self] item in
            self?.selectItem = item
            print("선택 아이템 ", self?.selectItem)
        }
        view.set(contentViewController: contentVC)
        view.track(scrollView: contentVC.tableView)
        view.isRemovalInteractionEnabled = false
    }
    
    private func layout() {
        fpc.addPanel(toParent: self)
    }
    
    var currentRegion = ""
    
    // 선택한 아이템 상세페이지로 이동시키기
    var selectItem = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async { [weak self] in
            self?.mainView.scrollView.setZoomScale(2, animated: true)
        }
        configureVC()
        bindViewModel()
    }
    
    func configureVC() {
        mainView.mapVCProtocol = self
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.background
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.txtPrimary,
            .font: UIFont.monospacedSystemFont(ofSize: 18, weight: .medium)
        ]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.topItem?.title = Strings.TabMap.title
        
        layout()
        fpc.hide(animated: true)
    }
    
    func bindViewModel() {
        
    }
}

class TableViewController: UITableViewController {
    
    var didSelect: ((String) -> Void)?
    
    private let items: [String] = [
        "option A",
        "option B",
        "option C",
        "option D",
        "option E",
        "option F",
        "option G"
    ]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = items[indexPath.row]
        cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? .systemGray6 : .systemGray3
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect?(items[indexPath.row])
    }
}

extension MapVC: FloatingPanelControllerDelegate {
    
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
//        print(fpc)
    }
}

extension MapVC: MapVCProtocol {
    func regionButtonClicked(regionName: String) {
        
        if currentRegion == regionName {
            switch fpc.state {
            case .half:
                fpc.move(to: .tip, animated: true)
            case .hidden:
                fpc.move(to: .tip, animated: true)
            case .tip:
                fpc.move(to: .tip, animated: true)
            default: break
            }
        } else {
            fpc.move(to: .half, animated: true)
        }
        currentRegion = regionName
        
//        switch fpc.state {
//        case .half:
//            fpc.move(to: .full, animated: true)
//        case .hidden:
//            fpc.move(to: .tip, animated: true)
//        case .tip:
//            fpc.move(to: .half, animated: true)
//        default: break
//        }
    }
}

