//
//  ChartViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/18.
//

import Foundation

final class ChartViewModel: BaseViewModel {
    
    enum ChartUIState<T> {
        case initValue
        case loading
        case success(data: T)
        case error(msg: String)
    }
    
    struct ChartData {
        let dataPoints: [String]
        let values: [Double]
        let totalNum: String
    }
    
    private var travelBigDataRepository: TravelBigDataRepository
    
    init(travelBigDataRepository: TravelBigDataRepository) {
        self.travelBigDataRepository = travelBigDataRepository
    }
    
    var state: Observable<ChartUIState<ChartData>> = Observable(.initValue)
    
    func fetchTravelVistor(startDate: String, endDate: String) {
        state.value = .loading
        
        travelBigDataRepository.requestTravelBigData(startDate: startDate, endDate: endDate) { [weak self] response in
            switch response {
            case .success(let success):
                let result = success.response.body.items.item
                var chartDict: [String:Double] = [:]
                let areaCode = RegionType.allCases.map { $0.rawValue }
                
                // 0 으로 시작해서 하나씩 더하기
                areaCode.forEach { code in
                    chartDict.updateValue(0.0, forKey: code)
                }
                
                let regions = RegionType.allCases
                regions.forEach { type in
                    result.forEach { visitorItem in
                        if type.rawValue == visitorItem.areaCode {
                            guard let totalTourist = chartDict[type.rawValue] else { return }
                            guard let visitorNum = Double(visitorItem.touNum) else { return }
                            chartDict.updateValue(totalTourist + visitorNum, forKey: type.rawValue)
                        }
                    }
                }
                
                var dataPoints: [String] = []
                var values: [Double] = []
                var etcValue = 0.0  // 2.1프로 미만인 지역은 기타로 합쳐서 보여주기
                
                let sum = Array(chartDict.values).sumOfSelf()
                chartDict.sorted { return $0.value > $1.value }.forEach { key, value in
                    let calculateVal = (value / sum) * 100
                    let result = round(calculateVal * pow(10,2)) / pow(10,2)
                    
                    if result >= 2.1 {
                        dataPoints.append(RegionType(rawValue: key)!.name)
                        values.append(result)
                    } else {
                        etcValue = etcValue + result
                    }
                }
                
                if etcValue > 0.0 {
                    dataPoints.append("etc")
                    values.append(etcValue)
                }
                
                let totalNum = round(sum * pow(10,2)) / pow(10,2)
                
                self?.state.value = .success(
                    data: ChartData(
                        dataPoints: dataPoints,
                        values: values, 
                        totalNum: makeCommaNum(num: totalNum))
                )
                
            case .failure(let failure):
                self?.state.value = .error(msg: failure.localizedDescription)
            }
        }
    }
}

private func makeCommaNum(num: Double) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = 2
    return numberFormatter.string(for: num) ?? ""
}
