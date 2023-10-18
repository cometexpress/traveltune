//
//  ChartVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/18.
//

import UIKit

final class ChartVC: BaseViewController<ChartView, ChartViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel?.fetchTravelVistor(startDate: "20220101", endDate: "20221231")
        viewModel?.state.bind { [weak self] state in
            guard let self else { return }
            switch state {
            case .initValue: Void()
            case .loading:
                LoadingIndicator.show()
            case .success(let chartData):
                self.mainView.setPieChart(dataPoints: chartData.dataPoints, values: chartData.values)
                mainView.showChartView()
                LoadingIndicator.hide()
            case .error(let msg):
                mainView.hideChartView()
                showToast(msg: Strings.ErrorMsg.errorLoadingData)
                LoadingIndicator.hide()
            }
        }
    }
    
    func configureVC() {
        mainView.chartVCProtocol = self
    }
    
}

extension ChartVC: ChartVCProtocol {
    
    func backClicked() {
        dismiss(animated: true)
    }
    
    func reloadClicked() {
        viewModel?.fetchTravelVistor(startDate: "20220101", endDate: "20221231")
    }
}
