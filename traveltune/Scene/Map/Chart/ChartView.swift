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
    
//    var barChartView = BarChartView().setup { view in
//        view.noDataText = "데이터가 없습니다"
//        view.noDataFont = .monospacedSystemFont(ofSize: 16, weight: .semibold)
//        view.noDataTextColor = .txtDisabled
//        view.xAxis.labelPosition = .bottom
//        //        view.xAxis.enabled = false
//        
//        view.leftAxis.enabled = false
//        view.rightAxis.enabled = false
//        view.drawBordersEnabled = false
//        view.minOffset = 0
//        view.animate(xAxisDuration: 0, yAxisDuration: 2.0, easingOption: .easeInOutSine)
//    }
    
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
        view.setExtraOffsets(left: 24, top: 0, right: 24, bottom: 0)
    }
    
//    func setBarChart(dataPoints: [String], values: [Double]) {
//        // 데이터 생성
//        var dataEntries: [BarChartDataEntry] = []
//        for i in 0..<dataPoints.count {
//            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
//            dataEntries.append(dataEntry)
//        }
//        
//        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "방문자 수")
//        
//        // 차트 컬러
//        chartDataSet.colors = [.systemBlue]
//        
//        // 데이터 삽입
//        let chartData = BarChartData(dataSet: chartDataSet)
//        barChartView.data = chartData
//        
//        // 선택 안되게
//        chartDataSet.highlightEnabled = false
//        // 줌 안되게
//        barChartView.doubleTapToZoomEnabled = false
//        barChartView.pinchZoomEnabled = false
//        
//        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
//        barChartView.xAxis.setLabelCount(dataPoints.count, force: false)
//        
//        //        barChartView.leftAxis.axisMinimum = 0.0
//        barChartView.xAxis.drawAxisLineEnabled = false
//    }
    
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
        pieChartDataSet.valueLinePart2Length = 0.3
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
    
    override func configureHierarchy() {
        addSubview(pieChartView)
    }
    
    override func configureLayout() {
        pieChartView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide).inset(24)
            make.width.equalTo(self.snp.width).multipliedBy(0.95)
            make.height.equalTo(self.snp.height).multipliedBy(0.7)
        }
    }
}
