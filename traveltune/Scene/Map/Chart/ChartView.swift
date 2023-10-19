//
//  ChartView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/18.
//

import UIKit
import DGCharts
import SnapKit

final class ChartView: BaseView {
    
    weak var chartVCProtocol: ChartVCProtocol?
    
    var pieChartView = PieChartView().setup { view in
//        view.noDataText = "데이터가 없습니다"
        view.noDataText = ""
        view.noDataFont = .monospacedSystemFont(ofSize: 16, weight: .semibold)
        view.noDataTextColor = .txtDisabled
        view.drawHoleEnabled = false
        
//        let descrip = Description()
//        descrip.text = "방문자 수"
//        view.chartDescription = descrip

        view.isUserInteractionEnabled = false

        let spacing: CGFloat = 12
        let count: CGFloat = 30
        let width: CGFloat = UIScreen.main.bounds.width - (spacing * (count + 1))
        
        print(width)
        
        let l = view.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.formSize = CGFloat(width)
        l.xEntrySpace = spacing
        l.yEntrySpace = width
        l.yOffset = spacing
//        l.formToTextSpace = CGFloat(6)
//        l.calculatedLabelSizes = [CGSize(width: 20, height: 16)]
        
        view.animate(xAxisDuration: 1, easingOption: .easeInSine)
        view.setExtraOffsets(left: 26, top: 0, right: 26, bottom: 0)
    }
    
    private let titleLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 18, weight: .bold)
        view.textAlignment = .center
        view.text = Strings.Chart.title
    }
    
    private lazy var loadFailView = UIView().setup { view in
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(reloadViewClicked))
        view.addGestureRecognizer(tap)
        view.isHidden = true
    }
    
    private let reloadImageView = UIImageView().setup { view in
        let configuration = UIImage.SymbolConfiguration(pointSize: 24)
        view.image = .reload.withConfiguration(configuration).withTintColor(.txtDisabled, renderingMode: .alwaysOriginal)        
    }
    
    private let reloadLabel = UILabel().setup { view in
        view.text = Strings.Common.retry
        view.font = .monospacedSystemFont(ofSize: 16, weight: .regular)
        view.textColor = .txtDisabled
    }
    
    private lazy var backButton = UIButton().setup { view in
        let configuration = UIImage.SymbolConfiguration(pointSize: 20)
        view.setImage(.xmark.withConfiguration(configuration).withTintColor(.txtSecondary, renderingMode: .alwaysOriginal), for: .normal)
        view.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
    }
    
    private let guideTotalTravelLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        view.text = Strings.Chart.totalNumberOfTourists
        view.textColor = .txtPrimary
        view.isHidden = true
    }
    
    var totalTravelNumLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 18, weight: .bold)
        view.textColor = .primary
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.5
    }
    
    var yearLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 16, weight: .semibold)
        view.textColor = .txtPrimary
        view.textAlignment = .center
    }
    
    @objc private func reloadViewClicked() {
        chartVCProtocol?.reloadClicked()
    }
    
    @objc func backButtonClicked() {
        chartVCProtocol?.backClicked()
    }
    
    func setPieChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        dataPoints.enumerated().forEach { index, name in
            let dataEntry = PieChartDataEntry(value: values[index], label: name, data: name as AnyObject)
            dataEntries.append(dataEntry)
        }
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        pieChartDataSet.sliceSpace = 2
        pieChartDataSet.yValuePosition = .outsideSlice
        pieChartDataSet.valueLinePart1Length = 0.8
        pieChartDataSet.valueLinePart2Length = 0.1
        pieChartDataSet.valueLineColor = .txtPrimary

        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        let format = NumberFormatter()
        format.numberStyle = .percent
        format.maximumFractionDigits = 1
        format.multiplier = 1.0
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter: format))
        
        pieChartData.setValueFont(UIFont.monospacedSystemFont(ofSize: 9, weight: .regular))
        pieChartData.setValueTextColor(.txtPrimary)
        
        pieChartView.setNeedsDisplay()
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
        var colors: [UIColor] = []
        for _ in 0..<numbersOfColor {
            let red = CGFloat.random(in: 100..<220)
            let green = CGFloat.random(in: 100..<220)
            let blue = CGFloat.random(in: 100..<220)
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        return colors
    }
    
    func showChartView() {
        loadFailView.isHidden = true
        pieChartView.isHidden = false
        guideTotalTravelLabel.isHidden = false
    }
    
    func hideChartView() {
        pieChartView.isHidden = true
        guideTotalTravelLabel.isHidden = true
        loadFailView.isHidden = false
    }
    
    override func configureHierarchy() {
        addSubview(titleLabel)
        addSubview(backButton)
        addSubview(yearLabel)
        addSubview(guideTotalTravelLabel)
        addSubview(totalTravelNumLabel)
        loadFailView.addSubview(reloadLabel)
        loadFailView.addSubview(reloadImageView)
        addSubview(loadFailView)
        addSubview(pieChartView)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalTo(titleLabel)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
            make.horizontalEdges.equalToSuperview().inset(32)
        }
        
        guideTotalTravelLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        guideTotalTravelLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        guideTotalTravelLabel.snp.makeConstraints { make in
            make.top.equalTo(yearLabel.snp.bottom).offset(24)
            make.leading.equalTo(yearLabel)
        }
                
        totalTravelNumLabel.snp.makeConstraints { make in
            make.centerY.equalTo(guideTotalTravelLabel)
            make.leading.equalTo(guideTotalTravelLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(24)
        }
        
        loadFailView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
        reloadLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        reloadImageView.snp.makeConstraints { make in
            make.bottom.equalTo(reloadLabel.snp.top).offset(-6)
            make.centerX.equalToSuperview()
        }
        
        pieChartView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(totalTravelNumLabel.snp.bottom).offset(24)
//            make.bottom.equalTo(safeAreaLayoutGuide).inset(24)
            make.width.equalTo(self.snp.width).multipliedBy(0.95)
            make.height.equalTo(self.snp.height).multipliedBy(0.6)
        }
    }
}
