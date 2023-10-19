//
//  ChartVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/18.
//

import UIKit

final class ChartVC: BaseViewController<ChartView, ChartViewModel> {

    private var requestYear = ""
    private var startDate = ""
    private var endDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateRequestDate()
        configureVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel?.fetchTravelVistor(startDate: startDate, endDate: endDate)
        viewModel?.state.bind { [weak self] state in
            guard let self else { return }
            switch state {
            case .initValue: Void()
            case .loading:
                LoadingIndicator.show()
            case .success(let chartData):
                self.mainView.setPieChart(dataPoints: chartData.dataPoints, values: chartData.values)
                mainView.showChartView()
                mainView.totalTravelNumLabel.text = chartData.totalNum
                mainView.yearLabel.text = Strings.Chart.yearStandard.localized(with: [requestYear]) 
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
    
    private func updateRequestDate() {
        let date = Date()
        let previusYear = Calendar.current.date(byAdding: .year, value: -1, to: date)
        let formatterYear = DateFormatter()
        formatterYear.dateFormat = "yyyy"
        guard let previusYear else {
            startDate = "20210101"
            endDate = "20211231"
            return
        }
        var strPreviusYear = formatterYear.string(from: previusYear)
        print(strPreviusYear)
        startDate = "\(strPreviusYear)0101"
        endDate = "\(strPreviusYear)1231"
        requestYear = strPreviusYear
    }
    
}

extension ChartVC: ChartVCProtocol {
    
    func backClicked() {
        dismiss(animated: true)
    }
    
    func reloadClicked() {
        updateRequestDate()
        viewModel?.fetchTravelVistor(startDate: startDate, endDate: endDate)
    }
}
